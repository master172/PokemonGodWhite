extends CharacterBody2D

@export var speed = 256

@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D

@export var pokemon :game_pokemon = null

enum facingDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

var attacking = false

var current_facing_direction = facingDirection.UP

var input_direction = Vector2.ZERO
func _ready():
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,-1))
	current_facing_direction = facingDirection.UP
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
	
func get_input():
	
	if Input.is_action_pressed("Yes"):
		if attacking == false:
			if Input.is_action_just_pressed("W"):
				print(pokemon.get_learned_attack_name(0))
				pokemon.initiate_attack(0,self)
			elif Input.is_action_just_pressed("A"):
				print(pokemon.get_learned_attack_name(2))
			elif Input.is_action_just_pressed("S"):
				print(pokemon.get_learned_attack_name(3))
			elif Input.is_action_just_pressed("D"):
				print(pokemon.get_learned_attack_name(1))
		
	else:
		if input_direction.y == 0:
			input_direction.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
		if input_direction.x == 0:
			input_direction.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
			
		velocity = input_direction * speed
			
		if input_direction != Vector2.ZERO:
			animation_tree.set("parameters/Walk/blend_position",input_direction)
			input_to_facing_direction(input_direction)

func input_to_facing_direction(input_dir):
	if input_dir == Vector2(0,-1):
		current_facing_direction = facingDirection.UP
	elif input_dir == Vector2(0,1):
		current_facing_direction = facingDirection.DOWN
	elif input_dir == Vector2(-1,0):
		current_facing_direction = facingDirection.LEFT
	elif input_dir == Vector2(1,0):
		current_facing_direction= facingDirection.DOWN

func get_current_facing_direction():
	if current_facing_direction == facingDirection.UP:
		return Vector2(0,-1)
	elif current_facing_direction == facingDirection.DOWN:
		return Vector2(0,1)
	elif current_facing_direction == facingDirection.LEFT:
		return Vector2(-1,0)
	elif current_facing_direction == facingDirection.RIGHT:
		return Vector2(1,0)

func _physics_process(delta):
	get_input()
	move_and_slide()
