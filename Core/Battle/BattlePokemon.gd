class_name BattlePokemon
extends CharacterBody2D

@export var speed = 256

@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var sprite_2d = $Sprite2D
@onready var attack_selector = $AttackSelector

@export var pokemon :game_pokemon = null

var knockback_vector :Vector2 = Vector2.ZERO
enum facingDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

enum states {
	ATTACK_SELECTION,
	NORMAL
}

var state = states.NORMAL
var attacking = false

var current_facing_direction = facingDirection.UP

var init_delay = true

var input_direction = Vector2.ZERO

var knockback :bool = false
var self_knockback_vector:Vector2 = Vector2.ZERO
var knockback_modifier:int = 1000

var stop:bool = false
signal health_changed(body)

func _ready():
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",Vector2(0,-1))
	current_facing_direction = facingDirection.UP
	if pokemon != null:
		sprite_2d.texture = pokemon.get_overworld_sprite()
	
func get_input():
	
	if knockback == false and stop == false:
		if Input.is_action_just_pressed("Yes") and init_delay == false:
			if attacking == false:
				state = states.ATTACK_SELECTION
				attack_selector.start_radial()
			
		else:
			if state == states.NORMAL:
				input_direction = Input.get_vector("A", "D", "W", "S")
					
				velocity = input_direction * speed
					
				if input_direction != Vector2.ZERO:
					knockback_vector = input_direction
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
		current_facing_direction= facingDirection.RIGHT

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
	
	self_knockback_vector = self_knockback_vector.move_toward(Vector2.ZERO,10000*delta)
	

	if self_knockback_vector == Vector2.ZERO:
		knockback = false
	
	if knockback == true:
		velocity = self_knockback_vector
		
func _on_attack_selector_attack_chosen(attack):
	print(pokemon.get_learned_attack_name(attack))
	pokemon.initiate_attack(attack,self)


func _on_timer_timeout():
	init_delay = false


func _on_attack_selector_cancel():
	attacking = false
	state = states.NORMAL

func attack_prep():
	attacking = true

func attack_end():
	attacking = false
	state = states.NORMAL

func recive_damage(damage,User):
	pokemon.Health -= damage
	emit_signal("health_changed",self)
	receive_knockback(User,damage)
	if pokemon.Health <= 0:
		pokemon.Health = 0
		print("fainted")
	
	
func receive_knockback(body,damage):
	knockback = true
	self_knockback_vector = body.knockback_vector * knockback_modifier + Vector2(damage,damage)

func _stop():
	stop = true
