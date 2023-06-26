extends CharacterBody2D

#export variables
@export var walk_speed = 4.0
@export var Run_speed = 8.0
@export var can_surf : bool = true
@export var can_run = true
const TILE_SIZE = 16

#tile based movement variables
var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

#movement_state_variables
var is_running:bool = false
var is_surfing:bool = false
var speed = 4.0

#import variables
@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var collision_cast = $CollisionCast
@onready var water_cast = $WaterCast
@onready var surf_checker = $SurfChecker
@onready var shore_cast = $ShoreCast
@onready var shore_checker = $shoreChecker

#player_states
enum PlayerState {IDLE, TURNING, WALKING,SURFING}
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
		if playerState == PlayerState.SURFING:
			anim_state.travel("Surf")
			surf(delta)
		else:
			if is_running == false:
				anim_state.travel("Walk")
			else:
				anim_state.travel("Run")
			move(delta)
	else:
		if playerState == PlayerState.SURFING:
			anim_state.travel("Surf")
			is_moving = false
		else:
			anim_state.travel("Idle")
			is_moving = false
		
	#handle process functions
	check_water()
	check_shore()
	diable_casts()
	Run()

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = int(Input.is_action_pressed("D")) - int(Input.is_action_pressed("A"))
	if input_direction.x == 0:
		input_direction.y = int(Input.is_action_pressed("S")) - int(Input.is_action_pressed("W"))
	
	if input_direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position",input_direction)
		animation_tree.set("parameters/Walk/blend_position",input_direction)
		animation_tree.set("parameters/Turn/blend_position",input_direction)
		animation_tree.set("parameters/Surf/blend_position",input_direction)
		animation_tree.set("parameters/SurfTurn/blend_position",input_direction)
		animation_tree.set("parameters/Run/blend_position",input_direction)
		
		if need_to_turn() and is_running == false:
			surf_checker.position = Vector2(0,-8)
			shore_checker.position = Vector2(0,-8)
			if playerState == PlayerState.SURFING:
				var desired_step: Vector2 = input_direction * TILE_SIZE/2
			
				shore_cast.set_target_position(desired_step)
				shore_cast.force_raycast_update()
				
				playerState = PlayerState.TURNING
				anim_state.travel("SurfTurn")
			else:
				var desired_step: Vector2 = input_direction * TILE_SIZE/2
			
				water_cast.set_target_position(desired_step)
				water_cast.force_raycast_update()
				
				playerState = PlayerState.TURNING
				anim_state.travel("Turn")
				
				
				
		else:
			initial_position = position
			is_moving = true
	else:
		if playerState == PlayerState.SURFING:
			anim_state.travel("Surf")
		else:
			anim_state.travel("Idle")
	
func move(delta):
	#checking for collision
	#finding where the player wants to move
	update_casts()
	
	#stopping or allowing movement based on collision
	
	if collision_cast.is_colliding() or water_cast.is_colliding():
		is_moving = false
		percent_moved_to_next_tile = 0.0
	else:
		percent_moved_to_next_tile += speed * delta
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
	if is_surfing == true:
		playerState = PlayerState.SURFING
	else:
		playerState = PlayerState.IDLE

func check_water():
	if playerState != PlayerState.SURFING:
		if Input.is_action_just_pressed("CheckWater"):
			if water_cast.is_colliding():
				var desired_step: Vector2
				if get_current_facing_direction() != Vector2(0,-1):
					desired_step = (get_current_facing_direction() * TILE_SIZE * 2)+Vector2(0,-8)
				else:
					desired_step = (get_current_facing_direction() * TILE_SIZE * 1.5)
					
				surf_checker.position = desired_step
				

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
	start_surfing()

func surf(delta):
	var desired_step: Vector2 = input_direction * TILE_SIZE/2
	
	update_casts()
	
	#stopping or allowing movement based on collision
	
	if shore_cast.is_colliding():
		is_moving = false
		percent_moved_to_next_tile = 0.0
	else:
		percent_moved_to_next_tile += speed * delta
		if percent_moved_to_next_tile >= 1:
			position = initial_position +(TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
		else:
			position = initial_position +(TILE_SIZE * input_direction * percent_moved_to_next_tile)

func start_surfing():
	if can_surf == true:
		is_surfing = true
		playerState = PlayerState.SURFING
		position = surf_checker.global_position -Vector2(0,-8)
		surf_checker.position = Vector2(0,-8)
		shore_checker.position = Vector2(0,-8)


func _on_shore_checker_body_entered(body):
	if playerState == PlayerState.SURFING:
		is_surfing = false
		playerState = PlayerState.IDLE
		position = shore_checker.global_position-Vector2(0,-8)
		surf_checker.position = Vector2(0,-8)
		shore_checker.position = Vector2(0,-8)

func check_shore():
	if playerState == PlayerState.SURFING:
		if Input.is_action_just_pressed("CheckWater"):
			if shore_cast.is_colliding():
				var desired_step: Vector2
				if get_current_facing_direction() != Vector2(0,1):
					desired_step = (get_current_facing_direction() * TILE_SIZE * 2)+Vector2(0,-8)
				else:
					desired_step = (get_current_facing_direction() * TILE_SIZE)+Vector2(0,-4)
					
				shore_checker.position = desired_step
				

func update_casts():
	var desired_step: Vector2 = input_direction * TILE_SIZE/2
	
	#checking for collideable collision
	collision_cast.set_target_position(desired_step)
	collision_cast.force_raycast_update()
	
	#checking for water collision
	water_cast.set_target_position(desired_step)
	water_cast.force_raycast_update()
	
	shore_cast.set_target_position(desired_step)
	shore_cast.force_raycast_update()

func diable_casts():
	if playerState != PlayerState.SURFING:
		shore_cast.enabled = false
	else:
		shore_cast.enabled = true

func Run():
	if can_run == true:
		if Input.is_action_pressed("Run"):
			is_running = true
			speed = Run_speed
		else:
			is_running = false
			speed = walk_speed
