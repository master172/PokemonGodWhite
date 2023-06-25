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
@onready var collision_cast = $CollisionCast
@onready var water_cast = $WaterCast
@onready var surf_checker = $SurfChecker

#player_states
enum PlayerState {IDLE, TURNING, WALKING}
enum FacingDirection {LEFT,RIGHT,UP,DOWN}

var playerState = PlayerState.IDLE
var facingDirection = FacingDirection.DOWN

func _ready():
	initial_position = position
	animation_tree.active = true

func _physics_process(delta):
	
	#handle movement
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
		
		#handle water checking
	check_water()

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
			var desired_step: Vector2 = input_direction * TILE_SIZE/2
			
			water_cast.set_target_position(desired_step)
			water_cast.force_raycast_update()
			surf_checker.position = Vector2(0,-8)
			playerState = PlayerState.TURNING
			anim_state.travel("Turn")
		else:
			initial_position = position
			is_moving = true
	else:
		anim_state.travel("Idle")
	
func move(delta):
	#checking for collision
	#finding where the player wants to move
	var desired_step: Vector2 = input_direction * TILE_SIZE/2
	
	#checking for collideable collision
	collision_cast.set_target_position(desired_step)
	collision_cast.force_raycast_update()
	
	#checking for water collision
	water_cast.set_target_position(desired_step)
	water_cast.force_raycast_update()
	
	#stopping or allowing movement based on collision
	
	if collision_cast.is_colliding() or water_cast.is_colliding():
		is_moving = false
		percent_moved_to_next_tile = 0.0
	else:
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

func check_water():
	if Input.is_action_just_pressed("CheckWater"):
		if water_cast.is_colliding():
			var desired_step: Vector2
			if get_current_facing_direction() != Vector2(0,-1):
				desired_step = (get_current_facing_direction() * TILE_SIZE * 2)+Vector2(0,-8)
			else:
				desired_step = (get_current_facing_direction() * TILE_SIZE * 1.5)
				
			surf_checker.position = desired_step
			print("shore ahead")

func get_current_facing_direction():
	if facingDirection == FacingDirection.UP:
		return Vector2(0,-1)
	elif facingDirection == FacingDirection.DOWN:
		return Vector2(0,1)
	elif facingDirection == FacingDirection.LEFT:
		return Vector2(-1,0)
	elif facingDirection == FacingDirection.RIGHT:
		return Vector2(1,0)


func _on_surf_checker_body_entered(body):
	print("can surf")
