extends CharacterBody2D

signal player_moving_signal
signal player_stopped_signal

signal player_entering_door_signal
signal player_entered_door_signal
#export variables

@export_category("Movement")
@export_group("MovementSpeed")
@export var walk_speed :float = 5.0
@export var jump_speed :float= 4.0
@export var Run_speed :float = 8.0
@export var Cycle_speed :float= 12.0

@export_group("CanMove")
@export var can_surf : bool = true
@export var can_run : bool = true
@export var can_cycle : bool = true
@export var can_move : bool = true

const TILE_SIZE = 16

const LandingDustEffect = preload("res://src/player/ash/landing_dust_effect.tscn")
const SurfChecker = preload("res://src/player/ash/surf_checker.tscn")
const Pokemon_manager = preload("res://src/player/ash/pokemon_manager.tscn")

#tile based movement variables
var initial_position :Vector2 = Vector2(0,0)
var input_direction :Vector2 = Vector2(0,1)
var is_moving :bool = false
var percent_moved_to_next_tile :float= 0.0

#movement_state_variables
var is_running:bool = false
var is_surfing:bool = false
var is_cycling:bool = false
var jumping_over_ledge:bool = false

var surf_timer_active:bool = false
var speed :float= 4.0

#import variables
@onready var animation_tree = $AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@onready var collision_cast = $CollisionCast
@onready var ledge_cast = $LedgeCast
@onready var shadow = $Shadow
@onready var door_cast = $DoorCast
@onready var surf_timer = $SurfTimer
@onready var skin = $Skin
@onready var animation_player = $AnimationPlayer
@onready var interaction_cast = $InteractionCast
@onready var saver = $Saver
@onready var footstep = $AudioManager/Footstep

var pokemon_manager
var pokemon_following:bool = false
var to_pokemon_follow:bool = true
#player_states
enum PlayerState {IDLE, TURNING, WALKING,SURFING,CYCLING}
enum FacingDirection {LEFT,RIGHT,UP,DOWN}

var playerState = PlayerState.IDLE
var facingDirection = FacingDirection.DOWN
var previous_facing_direction = FacingDirection.DOWN
#ledge_jumping_variables
var ledge_direction:Vector2 = Vector2.ZERO
var just_ledge_jumped = false
var jump_direction:Vector2 = Vector2.ZERO

var collided:bool = false

var poke_pos:Vector2 = Vector2.ZERO
var pokeDirection:Vector2 = Vector2.ZERO

var player_start:bool = false

signal player_ready

func _ready():

	Utils.Player = self
	initial_position = position
	animation_tree.active = true
	shadow.visible = false
	skin.visible = true
	
	#set looking direction
	if Utils.get_scene_manager() != null:
		if Utils.get_scene_manager().first_time_start == true:
			poke_pos = self.global_position
			
		if Utils.get_scene_manager().first_time_start == false:
			await saver.applying_done
	
	animation_tree.set("parameters/Idle/blend_position",input_direction)
	animation_tree.set("parameters/Walk/blend_position",input_direction)
	animation_tree.set("parameters/Turn/blend_position",input_direction)
	animation_tree.set("parameters/Surf/blend_position",input_direction)
	animation_tree.set("parameters/SurfTurn/blend_position",input_direction)
	animation_tree.set("parameters/Run/blend_position",input_direction)
	animation_tree.set("parameters/cycle/blend_position",input_direction)
	animation_tree.set("parameters/cycleIdle/blend_position",input_direction)
	animation_tree.set("parameters/cycleTurn/blend_position",input_direction)
	
	emit_signal("player_ready")

func set_poke_pos_dir(val1:Vector2,val2):
	poke_pos = val1
	pokeDirection = val2
func load_process():
	saver.load_data()
	load_data(saver.playerData)
	
func add_overworld_pokemon(set_see:bool = true,initial:bool = true):
	if initial == true:
		var scene_manager = Utils.get_scene_manager()
		if scene_manager != null:
			await scene_manager.data_set_finished
			
	pokemon_manager = Pokemon_manager.instantiate()
	get_parent().call_deferred("add_child",pokemon_manager)
	pokemon_following = true
	to_pokemon_follow = false
	pokemon_manager.global_position = poke_pos
	pokemon_manager.set_direction(pokeDirection)
	
	if set_see == true:
		await pokemon_manager.ready
		pokemon_manager.set_seeable()

func remove_overworld_pokemon():
	if is_instance_valid(pokemon_manager):
		pokemon_manager.queue_free()
		pokemon_following = false
	to_pokemon_follow = false
		
func _physics_process(delta):
	
	#handle movement
	if playerState == PlayerState.TURNING or can_move == false:
		return
	elif is_moving == false:
		process_player_input()
		
	elif input_direction != Vector2.ZERO:
		if playerState == PlayerState.SURFING:
			anim_state.travel("Surf")
		elif playerState == PlayerState.CYCLING:
			anim_state.travel("cycle")
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
	Run()
	cycle()
	speed_handler()
#	get_clicked_tile_power()
	check_ledge_direction()
	check_interaction()

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

			if playerState == PlayerState.SURFING:
				playerState = PlayerState.TURNING
				anim_state.travel("SurfTurn")
			else:
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
		previous_facing_direction = facingDirection
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

func Run():
	if can_run == true:
		if not is_cycling and not is_surfing:
			if Input.is_action_pressed("Run"):
				is_running = true
				
			else:
				is_running = false

func cycle():
	if can_cycle == true:
		if Input.is_action_just_pressed("cycleQuick"):
			if is_cycling == false and playerState == PlayerState.IDLE:
				if not is_surfing:
					remove_overworld_pokemon()
					is_cycling = true
					playerState = PlayerState.CYCLING
				else:
					remove_overworld_pokemon()
					is_cycling = false
					playerState = PlayerState.SURFING
			elif is_cycling == true:
				to_pokemon_follow = true
				is_cycling = false
				playerState = PlayerState.IDLE
				poke_pos = self.position
				pokeDirection = self.get_current_facing_direction()
				

func speed_handler():
	if is_running == true:
		speed = Run_speed
	elif is_cycling == true:
		speed = Cycle_speed
	else:
		speed = walk_speed

func move(delta):
	update_casts()
	#stopping or allowing movement based on collision
	
	if door_cast.is_colliding():
		just_ledge_jumped = false
		ledge_direction = Vector2.ZERO
		
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_entering_door_signal")
			ManageOverworldPokemon("moving")
		percent_moved_to_next_tile += speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position + input_direction * TILE_SIZE
			percent_moved_to_next_tile = 0.0
			is_moving = false
			can_move = false
			animation_player.play("dissapear")
			ManageOverworldPokemon("turned")
		else:
			position = initial_position +(TILE_SIZE * input_direction * percent_moved_to_next_tile)
			
	elif (ledge_cast.is_colliding() and ledge_direction == get_current_facing_direction()) or jumping_over_ledge == true:
		just_ledge_jumped = true
		if percent_moved_to_next_tile == 0.0:
			ManageOverworldPokemon("ledge")
			
			
		percent_moved_to_next_tile += jump_speed * delta
		
		if percent_moved_to_next_tile >= 2.0:
			position = initial_position + (input_direction * TILE_SIZE * 2)
			
			percent_moved_to_next_tile = 0.0
			is_moving = false
			jumping_over_ledge = false
			shadow.visible = false
			
			var DustEffect = LandingDustEffect.instantiate()
			DustEffect.position = position-Vector2(0,8)
			get_tree().current_scene.add_child(DustEffect)
			ledge_direction = Vector2.ZERO
		else:
			shadow.visible = true
			jumping_over_ledge = true
			if ledge_direction == Vector2(0,1):
				var input = input_direction.y * TILE_SIZE * percent_moved_to_next_tile
				position.y = initial_position.y + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
			elif ledge_direction == Vector2(0,-1):
				var input = input_direction.y * TILE_SIZE * percent_moved_to_next_tile
				position.y = initial_position.y + (-0.96 - 0.53 * input - 0.05 * pow(input, 2))
			elif ledge_direction == Vector2(-1,0):
				var input = input_direction.x * TILE_SIZE * percent_moved_to_next_tile
				position.x = initial_position.x + (-0.96 - 0.53 * input - 0.05 * pow(input, 2))
			elif ledge_direction == Vector2(1,0):
				var input = input_direction.x * TILE_SIZE * percent_moved_to_next_tile
				position.x = initial_position.x + (-0.96 - 0.53 * input + 0.05 * pow(input, 2))
			
			jump_direction = ledge_direction

		
	elif !collision_cast.is_colliding():
		just_ledge_jumped = false
		ledge_direction = Vector2.ZERO
		
		if percent_moved_to_next_tile == 0.0:
			emit_signal("player_moving_signal")
			
			if !collision_cast.is_colliding() and !ledge_cast.is_colliding():
				ManageOverworldPokemon("moving")
			
		percent_moved_to_next_tile += speed * delta
		if percent_moved_to_next_tile >= 1.0:
			position = initial_position +(TILE_SIZE * input_direction)
			percent_moved_to_next_tile = 0.0
			is_moving = false
			if pokeDirection ==Vector2.ZERO:
				pokeDirection = get_current_facing_direction()
				
			emit_signal("player_stopped_signal")
			ManageOverworldPokemon("turned")
			
		else:
			position = initial_position +(TILE_SIZE * input_direction * percent_moved_to_next_tile)
	else:
		ledge_direction = Vector2.ZERO
		just_ledge_jumped = false
		is_moving = false
		percent_moved_to_next_tile = 0.0
		
func get_current_facing_direction():
	if facingDirection == FacingDirection.UP:
		return Vector2(0,-1)
	elif facingDirection == FacingDirection.DOWN:
		return Vector2(0,1)
	elif facingDirection == FacingDirection.LEFT:
		return Vector2(-1,0)
	elif facingDirection == FacingDirection.RIGHT:
		return Vector2(1,0)

func check_water():
	if playerState != PlayerState.SURFING and surf_timer_active == false:
		if Input.is_action_just_pressed("CheckWater"):
			surf_timer_active = true
			surf_timer.start()
			var desired_place: Vector2 = Vector2.ZERO
			if get_current_facing_direction() == Vector2(0,-1):
				desired_place = Vector2(0,-24)
				
			elif get_current_facing_direction() == Vector2(0,1):
				desired_place = Vector2(0,24)
				
			elif get_current_facing_direction() == Vector2(-1,0):
				desired_place = Vector2(-32,-8)
				
			elif get_current_facing_direction() == Vector2(1,0):
				desired_place = Vector2(32,-8)
			
			if can_surf:
				var Surf = SurfChecker.instantiate()
				Surf.position = to_global(desired_place)
				get_tree().current_scene.add_child(Surf)
				Surf.process_tile(self,"surf")


func check_shore():
	if playerState == PlayerState.SURFING and surf_timer_active == false:
		if Input.is_action_just_pressed("CheckWater"):
			surf_timer_active = true
			surf_timer.start()
			var desired_place = Vector2.ZERO
			if get_current_facing_direction() == Vector2(0,-1):
				desired_place = Vector2(0,-40)
				
			elif get_current_facing_direction() == Vector2(0,1):
				desired_place = Vector2(0,8)
				
			elif get_current_facing_direction() == Vector2(-1,0):
				desired_place = Vector2(-32,-8)
				
			elif get_current_facing_direction() == Vector2(1,0):
				desired_place = Vector2(32,-8)
			
			if can_surf:
				var Surf = SurfChecker.instantiate()
				Surf.position = to_global(desired_place)
				get_tree().current_scene.add_child(Surf)
				Surf.process_tile(self,"shore")

func player_surfing(data,check):
	if data[0] != false:
		if check == "surf":
			if can_surf == true:
				remove_overworld_pokemon()
				is_surfing = true
				is_cycling = false
				is_running = false
				playerState = PlayerState.SURFING
				global_position = data[1]+Vector2(0,8)
		elif check == "shore":
			if playerState == PlayerState.SURFING:
				
				is_surfing = false
				playerState = PlayerState.IDLE
				global_position = data[1]+Vector2(0,8)
				to_pokemon_follow = true
				poke_pos = self.position
				pokeDirection = self.get_current_facing_direction()


func _on_surf_timer_timeout():
	surf_timer_active = false


func update_casts():
	var desired_step: Vector2 = input_direction * TILE_SIZE/2
	
	#checking for collideable collision
	
	ledge_cast.set_target_position(desired_step)
	ledge_cast.force_raycast_update()
	
	collision_cast.set_target_position(desired_step)
	collision_cast.force_raycast_update()
	
	door_cast.set_target_position(desired_step)
	door_cast.force_raycast_update()
	
	interaction_cast.set_target_position(desired_step)
	interaction_cast.force_raycast_update()




#func get_clicked_tile_power():
#	if Input.is_action_just_pressed("LeftClick"):
#		var clicked_cell = Utils.Tilemap.local_to_map(Utils.Tilemap.get_local_mouse_position())
#		var data =  Utils.Tilemap.get_cell_tile_data(0, clicked_cell)
#		if data:
#			print(data.get_custom_data("surf"))
#		else:
#			print("null")

func entered_door():
	emit_signal("player_entered_door_signal")

func set_spawn(location:Vector2,direction:Vector2):
		animation_tree.set("parameters/Idle/blend_position",direction)
		animation_tree.set("parameters/Walk/blend_position",direction)
		animation_tree.set("parameters/Turn/blend_position",direction)
		animation_tree.set("parameters/Surf/blend_position",direction)
		animation_tree.set("parameters/SurfTurn/blend_position",direction)
		animation_tree.set("parameters/Run/blend_position",direction)
		animation_tree.set("parameters/cycle/blend_position",direction)
		animation_tree.set("parameters/cycleIdle/blend_position",direction)
		animation_tree.set("parameters/cycleTurn/blend_position",direction)
		
		position = location
		facingDirection = facing_direction_to_enum(direction)

func facing_direction_to_enum(direction:Vector2):
	if direction == Vector2(0,-1):
		return FacingDirection.UP
	elif direction == Vector2(0,1):
		return FacingDirection.DOWN
	elif direction == Vector2(-1,0):
		return FacingDirection.LEFT
	elif direction == Vector2(1,0):
		return FacingDirection.RIGHT
		
func check_ledge_direction():
	if ledge_cast.is_colliding():
		var body_rid = ledge_cast.get_collider_rid()
		var collided_tile_cords = Utils.Tilemap.get_coords_for_body_rid(body_rid)
			
		var tile_data = Utils.Tilemap.get_cell_tile_data(1,collided_tile_cords)
		if tile_data:
			ledge_direction = tile_data.get_custom_data("ledgeDirection")

func check_interaction():
	if interaction_cast.is_colliding():
		
		if Input.is_action_just_pressed("Yes") and Utils.DialogProcessing == false:
	
			var interactable = interaction_cast.get_collider()
			if Utils.DialogBar != null:
				interactable._interact()

func ManageOverworldPokemon(case:String):
	if pokemon_following == true:
		var following_speed:float = 0.2
		if speed == walk_speed:
			following_speed = 0.2
		elif speed == Run_speed:
			following_speed = 0.1
		
		if case.to_lower() == "moving":
			pokemon_manager.change_position(self.global_position,following_speed,get_current_facing_direction())
		elif case.to_lower() == "ledge":
			pokemon_manager.change_position_to_ledge(self.global_position,0.4,get_current_facing_direction())
		pokemon_manager.set_seeable()
	
	if to_pokemon_follow == true and case.to_lower() == "turned":
		add_overworld_pokemon(true,false)

func save_data():
	saver.playerData.change_pos(floor(position))
	saver.playerData.change_input_dir(get_current_facing_direction())
	saver.playerData.change_cycling(is_cycling)
	saver.playerData.change_surfing(is_surfing)
	saver.playerData.change_playerState(playerState)
	saver.playerData.change_pokemon_following(pokemon_following)
	saver.playerData.change_can_pokemon_follow(to_pokemon_follow)
	saver.playerData.change_facing_direction(facingDirection)
	saver.playerData.change_poke_pos(poke_pos + Vector2(0,16))
	saver.playerData.change_poke_dir(pokeDirection)
	saver.save_data()

func load_data(playerDat):
	saver.apply_data(self)
	

func check_to_add_overworld_pokemon(set_see:bool = true):
	if pokemon_following == true:
	
		add_overworld_pokemon(set_see)

func change_animation(state:bool):
	animation_tree.active = state
	
func first_start():
	var pikachu = load("res://Core/Pokemon/MainPikachu.tres")
	var MainPikachu:game_pokemon = game_pokemon.new(pikachu,5,"Alpha")
	AllyPokemon.add_pokemon(MainPikachu)

func play_footstep():
	footstep.play()

func finish_battle():
	change_animation(true)
