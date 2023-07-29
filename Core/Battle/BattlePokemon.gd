extends CharacterBody2D

@export var speed = 200

@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D

@export var pokemon :game_pokemon = null


var input_direction = Vector2.ZERO
func _ready():
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,-1))
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
func get_input():
	
	if Input.is_action_pressed("Yes"):
		if Input.is_action_just_pressed("W"):
			print("W")
		elif Input.is_action_just_pressed("A"):
			print("A")
		elif Input.is_action_just_pressed("S"):
			print("S")
		elif Input.is_action_just_pressed("D"):
			print("D")
		
		input_direction = Vector2.ZERO
		velocity = input_direction * speed
	else:
		if input_direction.y == 0:
			input_direction.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
		if input_direction.x == 0:
			input_direction.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
			
		velocity = input_direction * speed
			
		if input_direction != Vector2.ZERO:
			animation_tree.set("parameters/Walk/blend_position",input_direction)


func _physics_process(delta):
	get_input()
	move_and_slide()
