class_name PokeEnemy
extends CharacterBody2D

var movement_speed: float = 128.0

@export var max_speed = 40.0
@export var acceleration = 50.0
@onready var poke_cast = $PokeCast

@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D

var targetPokemon = null

var pokemon :game_pokemon

var health:int  = 200:
	set(new_value):
		health = new_value
		if health <= 0:
			queue_free()
	get:
		return health

func _ready():
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
