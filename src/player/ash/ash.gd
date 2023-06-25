extends CharacterBody2D

@export var  walk_speed = 4.0
const TILE_SIZE = 16

#tile based movement variables
var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

#import variables
@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")

#player_states
enum PlayerState {IDLE, TURNING, WALKING}
enum FacingDirection {LEFT,RIGHT,UP,DOWN}

var playerState = PlayerState.IDLE
var facingDirection = FacingDirection.DOWN

func _ready():
	initial_position = position
	animation_tree.active = true

func _physics_process(delta):
	if playerState == PlayerState.TURNING:
		return
	elif is_moving == false:
		process_player_input()
	elif input_direction != Vector2.ZERO:
		anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	
	if input_direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",input_direction)
		animation_tree.set("parameters/Walk/blend_position",input_direction)
		animation_tree.set("parameters/Turn/blend_position",input_direction)
		
		if need_to_turn():
			playerState = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")
	
func move(delta):
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 1:
		position = initial_position +(TILE_SIZE * input_direction)
		percent_moved_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position +(TILE_SIZE * input_direction * percent_moved_to_next_tile)
		

func need_to_turn():
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.LEFT
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.RIGHT
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.UP
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.DOWN
	
	if facingDirection != new_facing_direction:
		facingDirection = new_facing_direction
		return true
	
	facingDirection = new_facing_direction
	return false

func exit_turning_state():
	playerState = PlayerState.IDLE
