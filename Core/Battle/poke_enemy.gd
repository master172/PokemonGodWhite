class_name PokeEnemy
extends CharacterBody2D

var movement_speed: float = 128.0

@export var max_speed = 40.0
@export var acceleration = 50.0
@onready var poke_cast:RayCast2D = $PokeCast

@onready var animation_tree:AnimationTree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d:Sprite2D = $Sprite2D

@onready var enemy_follow_state:EnemyFollowState = $FiniteStateMachine/EnemyFollowState
@onready var melle_attack_state:MelleAttackState = $FiniteStateMachine/MelleAttackState
@onready var range_attack_state:RangeAttackState = $FiniteStateMachine/RangeAttackState
@onready var enemy_knock_back_state:EnemyKnockBackState = $FiniteStateMachine/EnemyKnockBackState
@onready var enemy_dodge_state:EnemyDodgeState = $FiniteStateMachine/EnemyDodgeState
@onready var stall_state:StallState = $FiniteStateMachine/StallState
@onready var enemy_idle_state:EnemyIdleState = $FiniteStateMachine/EnemyIdleState

@onready var finite_state_machine:FiniteStateMachine = $FiniteStateMachine

@onready var stun_timer = $StunTimer

var targetPokemon = null

var pokemon :game_pokemon
var knockback_vector :Vector2 = Vector2.ZERO
signal health_changed(body)

enum attacks {
	RANGE,
	MELLE
}

var attack = attacks.MELLE

var attack_num:int = 0

var Attack

signal defeated(name)

var stop:bool = false
var Stun:bool = false

var opposing_pokemons :Array[BattlePokemon] = []

func _ready():
	choose_attack()

	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
	
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,1))
	
func choose_attack():
	
	if pokemon != null:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
	
		var at = rng.randi_range(0,pokemon.get_learned_attacks())
		Attack = pokemon.get_learned_attack(at)
		attack = Attack.base_action.range
		attack_num = at
		print(pokemon.get_learned_attack(attack_num).base_action.name)
		
func _physics_process(delta):
	
	if Stun == true:
		velocity = Vector2.ZERO
		
	knockback_vector = velocity.normalized()
	#print(velocity)
	if targetPokemon == null:
		if BattleManager.AllyHolders != []:
			targetPokemon = BattleManager.AllyHolders[0]
	
	elif targetPokemon != null:
		poke_cast.set_target_position(to_local(targetPokemon.global_position))
	
	animation_tree.set("parameters/Walk/blend_position",velocity.normalized())
	
	move_and_slide()

func _on_navigation_agent_2d_navigation_finished():
	print(self.position)


func _on_enemy_follow_state_close_to():
	if pokemon.get_learned_attack(attack_num).base_action.range == 0:
		range_attack_state.set_variables(attack_num)
		finite_state_machine.change_state(range_attack_state)


func _on_enemy_follow_state_next_to():
	if pokemon.get_learned_attack(attack_num).base_action.range == 1:
		range_attack_state.set_variables(attack_num)
		finite_state_machine.change_state(melle_attack_state)

func recive_damage(damage,body,Attacker):
	pokemon.Health -= damage
	receive_knockback(body,damage)
	animate_hurt()
	if pokemon.Health <= 0:
		pokemon.fainted = true
		emit_signal("defeated",pokemon,Attacker,self)
		queue_free()
	emit_signal("health_changed",self)

func receive_knockback(body,damage):

	enemy_knock_back_state.set_variables(body.knockback_vector,damage)
	finite_state_machine.change_state(enemy_knock_back_state)


func _on_enemy_knock_back_state_finished():
	finite_state_machine.change_state(enemy_idle_state)

func get_current_facing_direction():
	return velocity.normalized()


func _on_range_attack_state_attack_finished(attack,user):
	if user == self and attack.User == self:
		
		finite_state_machine.change_state(enemy_idle_state)
		

func _on_melle_attack_state_attack_finished(attack,user):
	if user == self and attack.User == self:

		finite_state_machine.change_state(enemy_idle_state)

func _on_enemy_idle_state_done():
	if stop == false:
		finite_state_machine.change_state(enemy_follow_state)
	choose_attack()

func _on_range_attack_state_attack_landed(attack,user):
	if user == self:
		finite_state_machine.change_state(enemy_idle_state)


func _on_melle_attack_state_attack_landed(attack,user):
	if user == self:
		finite_state_machine.change_state(enemy_idle_state)

func _stop():
	stop = true
	print("what")
	finite_state_machine.change_state(stall_state)

func player_attacked(player):
	var rng = RandomNumberGenerator.new()
	var dodge_chance = 7
	var dodge_rng = rng.randi_range(0,dodge_chance)
	if dodge_rng > 0:
		if finite_state_machine.get_state() == enemy_follow_state or finite_state_machine.get_state() == enemy_idle_state:
			enemy_dodge_state.player_set(player)
			finite_state_machine.change_state(enemy_dodge_state)


func _on_enemy_dodge_state_finished():
	finite_state_machine.change_state(enemy_follow_state)


func _on_knock_back_area_body_entered(body):
	if body != self:
		if body.is_in_group("PlayerPokemon"):
			print_debug(body)
			receive_knockback(body,10)
			body.receive_knockback(self,10)

func animate_hurt():
	var tween = get_tree().create_tween()
	sprite_2d.modulate = Color(1, 0, 0)
	tween.tween_property(sprite_2d,"modulate",Color(1,1,1),0.5)

func animate_wait():
	var tween = get_tree().create_tween()
	sprite_2d.modulate = Color(0,0,0)
	tween.tween_property(sprite_2d,"modulate",Color(1,1,1),0.5)

func stun(duration:int = 2):
	stun_timer.start(duration)
	Stun = true

func _on_stun_timer_timeout():
	Stun = false

func get_pokemon():
	return pokemon
