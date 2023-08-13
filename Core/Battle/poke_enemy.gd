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
@onready var finite_state_machine:FiniteStateMachine = $FiniteStateMachine
@onready var range_attack_state:RangeAttackState = $FiniteStateMachine/RangeAttackState
@onready var enemy_knock_back_state:EnemyKnockBackState = $FiniteStateMachine/EnemyKnockBackState

var targetPokemon = null

var pokemon :game_pokemon

signal health_changed(body)

enum attacks {
	RANGE,
	MELLE
}

var attack = attacks.MELLE


func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	attack = rng.randi_range(0,1)
	print(attack)
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
	
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,1))
	
func _physics_process(delta):
	
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
	velocity = Vector2.ZERO
	if attack == 0:
		finite_state_machine.change_state(range_attack_state)


func _on_enemy_follow_state_next_to():
	velocity = Vector2.ZERO
	if attack == 1:
		finite_state_machine.change_state(melle_attack_state)

func recive_damage(damage,body):
	pokemon.Health -= damage
	receive_knockback(body,damage)
	if pokemon.Health <= 0:
		queue_free()
	emit_signal("health_changed",self)

func receive_knockback(body,damage):
	
#	var knockback_vector = body.knockback_vector
#	knockback = knockback_vector * knockback_modifier
#	reciving_knockback = true
#	knock_back_timer.start()
	enemy_knock_back_state.set_variables(body.knockback_vector,damage)
	finite_state_machine.change_state(enemy_knock_back_state)


func _on_enemy_knock_back_state_finished():
	finite_state_machine.change_state(enemy_follow_state)
	print("only once?")
