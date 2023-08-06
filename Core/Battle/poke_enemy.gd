class_name PokeEnemy
extends CharacterBody2D

var movement_speed: float = 128.0

@export var max_speed = 40.0
@export var acceleration = 50.0
@onready var poke_cast = $PokeCast

@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D

@onready var enemy_follow_state = $FiniteStateMachine/EnemyFollowState
@onready var melle_attack_state = $FiniteStateMachine/MelleAttackState
@onready var finite_state_machine:FiniteStateMachine = $FiniteStateMachine
@onready var range_attack_state = $FiniteStateMachine/RangeAttackState


var targetPokemon = null

var pokemon :game_pokemon

enum attacks {
	RANGE,
	MELLE
}

var attack = attacks.MELLE

var health:int  = 200:
	set(new_value):
		health = new_value
		if health <= 0:
			queue_free()
	get:
		return health

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	attack = rng.randi_range(0,1)
	print(attack)
	if game_pokemon != null:
		pass
	
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,1))
	
func _physics_process(delta):
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
