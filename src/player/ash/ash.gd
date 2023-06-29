extends CharacterBody2D

signal player_moving_signal
signal player_stopped_signal
#export variables
@export var walk_speed = 4.0
@export var jump_speed = 4.0
@export var Run_speed = 8.0
@export var Cycle_speed = 12.0
@export var can_surf : bool = true
@export var can_run : bool = true
@export var can_cycle : bool = true

const TILE_SIZE = 16

const LandingDustEffect = preload("res://src/player/ash/landing_dust_effect.tscn")

#tile based movement variables
var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

#movement_state_variables
var is_running:bool = false
var is_surfing:bool = false
var is_cycling:bool = false
var jumping_over_ledge:bool = false

var speed = 4.0

#import variables
@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var collision_cast = $CollisionCast
@onready var water_cast = $WaterCast
@onready var surf_checker = $SurfChecker
@onready var shore_cast = $ShoreCast
@onready var shore_checker = $shoreChecker
@onready var ledge_cast = $LedgeCast
@onready var shadow = $Shadow
@onready var door_cast = $DoorCast

#player_states
enum PlayerState {IDLE, TURNING, WALKING,SURFING,CYCLING}
enum FacingDirection {LEFT,RIGHT,UP,DOWN}

var playerState = PlayerState.IDLE
var facingDirection = FacingDirection.DOWN

func _ready():
	initial_position = position
	animation_tree.active = true
	shadow.visible = false
	
	surf_checker.get_child(0).disabled = true
	shore_checker.get_child(0).disabled = true
	
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
		elif playerState == PlayerState.CYCLING:
			anim_state.travel("cycle")
			move(delta)
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
		elif playerState == PlayerState.CYCLING:
			anim_state.travel("cycleIdle")
			is_moving = false
		else:
			anim_state.travel("Idle")
			is_moving = false
		
	#handle process functions
	check_water()
	check_shore()
	diable_casts()
	Run()
	switch_cycling()
	speed_handler()

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
		animation_tree.set("parameters/cycle/blend_position",input_direction)
		animation_tree.set("parameters/cycleIdle/blend_position",input_direction)
		animation_tree.set("parameters/cycleTurn/blend_position",input_direction)
		
		if need_to_turn() and is_running == false and is_cycling == false:
			surf_checker.position = Vector2(0,-8)
			shore_checker.position = Vector2(0,-8)
			if playerState == PlayerState.SURFING :
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
		elif playerState == PlayerState.CYCLING:
			anim_state.travel("cycleIdle")
		else:
			anim_state.travel("Idle")
	
func move(delta):
	update_casts()
	
	#stopping or allowing movement based on collision
	
	if (ledge_cast.is_colliding() and get_current_facing_direction() == Vector2(0,1)) or jumping_over_ledge == true:
		percent_moved_to_next_tile += jump_speed * delta
		if percent_moved_to_next_tile >= 2.0:
			position = initial_position + input_direction * TILE_SIZE * 2
			percent_moved_to_next_tile = 0.0
			is_moving = false
			jumping_over_ledge = false
			shadow.visible = false
			
			var DustEffect = LandingDustEffect.instantiate()
			DustEffect.position = position-Vector2(0,8)
			get_tree().current_scene.add_child(DustEffect)
			
			
		else:
			shadow.visible = true
			jumping_over_ledge = true
			var input = input_direction.y * TILE_SIZE * percent_moved_to_next_tile
			position.y = initial_position.y + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
	elif collision_cast.is_colliding() or water_cast.is_colliding():
		is_moving = false
		percent_moved_to_next_tile = 0.0
	else:
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_moving_signal")
		percent_moved_to_next_tile += speed * delta
		if percent_moved_to_next_tile >= 1:
			position = initial_position +(TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			emit_signal("player_stopped_signal")
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
	elif is_cycling == true:
		playerState = PlayerState.CYCLING
	else:
		playerState = PlayerState.IDLE

func check_water():
	if playerState != PlayerState.SURFING:
		if Input.is_action_just_pressed("CheckWater"):
			if water_cast.is_colliding():
				var desired_place: Vector2 = Vector2.ZERO
				if get_current_facing_direction() == Vector2(0,-1):
					surf_checker.position = Vector2(0,-24)
				elif get_current_facing_direction() == Vector2(0,1):
					surf_checker.position = Vector2(0,24)
				elif get_current_facing_direction() == Vector2(-1,0):
					surf_checker.position = Vector2(-32,-8)
				elif get_current_facing_direction() == Vector2(1,0):
					surf_checker.position = Vector2(32,-8)
				
				surf_checker.get_child(0).disabled = false
				

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
		is_cycling = false
		is_running = false
		playerState = PlayerState.SURFING
		position = surf_checker.global_position + Vector2(0,8)
		surf_checker.position = Vector2(0,-8)
		shore_checker.position = Vector2(0,-8)
		surf_checker.get_child(0).set_deferred("disabled",true)


func check_shore():
	if playerState == PlayerState.SURFING:
		if Input.is_action_just_pressed("CheckWater"):
			if shore_cast.is_colliding():
				if get_current_facing_direction() == Vector2(0,-1):
					shore_checker.position = Vector2(0,-40)
				elif get_current_facing_direction() == Vector2(0,1):
					shore_checker.position = Vector2(0,8)
				elif get_current_facing_direction() == Vector2(-1,0):
					shore_checker.position = Vector2(-32,-8)
				elif get_current_facing_direction() == Vector2(1,0):
					shore_checker.position = Vector2(32,-8)
				
				shore_checker.get_child(0).disabled = false
					
				

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
	
	ledge_cast.set_target_position(desired_step)
	ledge_cast.force_raycast_update()

func diable_casts():
	if playerState != PlayerState.SURFING:
		shore_cast.enabled = false
	else:
		shore_cast.enabled = true

func Run():
	if can_run == true:
		if not is_cycling and not is_surfing:
			if Input.is_action_pressed("Run"):
				is_running = true
				
			else:
				is_running = false

func switch_cycling():
	if can_cycle == true:
		if Input.is_action_just_pressed("cycleQuick"):
			if is_cycling == false and playerState == PlayerState.IDLE:
				if not is_surfing:
					is_cycling = true
					playerState = PlayerState.CYCLING
				else:
					is_cycling = false
					playerState = PlayerState.SURFING
			elif is_cycling == true:
				is_cycling = false
				playerState = PlayerState.IDLE
				

func speed_handler():
	if is_running == true:
		speed = Run_speed
	elif is_cycling == true:
		speed = Cycle_speed
	else:
		speed = walk_speed


func _on_surf_checker_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var dat = process_tilemap_collision(body,body_rid,"surf")

func process_tilemap_collision(body: Node2D, body_rid:RID,check:String):
	var returning_value = []
	var can_return_non_zero:bool = true
	var current_tilemap = body
	
	var collison_cords = current_tilemap.get_coords_for_body_rid(body_rid)
	
	for index in current_tilemap.get_layers_count():
		var tile_data = current_tilemap.get_cell_tile_data(index,collison_cords)
		if tile_data:
			returning_value.append(tile_data.get_custom_data("surf"))
		else:
			pass
	
	if check == "shore":
		if returning_value != [-1]:
			return 0
		else:
			return -1
	


func _on_shore_checker_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body is TileMap:
		var dat = process_tilemap_collision(body,body_rid,"shore")
		if dat == -1:
			if playerState == PlayerState.SURFING:
				is_surfing = false
				playerState = PlayerState.IDLE
				position = shore_checker.global_position + Vector2(0,8)
				surf_checker.position = Vector2(0,-8)
				shore_checker.position = Vector2(0,-8)
				shore_checker.get_child(0).set_deferred("disabled",true)

func get_surf_data():
	pass
