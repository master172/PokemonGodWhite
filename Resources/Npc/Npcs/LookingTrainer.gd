extends trainer
class_name looking_trainer

@export var LineOfSight :RayCast2D
@export var exclamation :Sprite2D

@export var look_distance:int = 1

var player

var to_move_pos:= Vector2(0,0)
var distance_to_move :int

var move_speed = 64

var can_move = false

var player_spotted:bool = false

signal reached_target

func _ready():
	save_prep()
	basic_set()
	
	await load_done
	looking_set()
	

func looking_set():
	if batteled == true:
		print("battle finished")
		return
	if exclamation != null:
		exclamation.visible = false
	
	player = Utils.get_player()
	
	set_line_of_sight()
	
	if player != null:
		player.connect("player_stopped_signal",check)

func set_line_of_sight():
	if LineOfSight != null:
		LineOfSight.target_position = (look_distance * 16) * looking_direction
		
		
func check():
	if exclamation != null and can_battle == true:
		if not LineOfSight.is_colliding():
			exclamation.visible = false
		else:
			if player != null:
				if player.is_moving == true:
					await player.player_stopped_signal
			print("can_see")
			exclamation.visible = true
			player_spotted = true
			handle_moving(LineOfSight.get_collision_point())
	
func handle_moving(pos:Vector2):
	can_move = true
	
	
	set_to_move(pos)
	set_distance_to_move()
	move_animation()
	print(distance_to_move)
	print((distance_to_move*(looking_direction * 16)))
	
	if player_spotted == true:
		player.stop()
		player.stop_animation()
	
	
func _physics_process(delta):
	if can_move == true:
		move(delta)
		
func set_to_move(value:Vector2):
	if looking_direction == Vector2(0,-1):
		to_move_pos = value - 16*looking_direction
	elif looking_direction == Vector2(0,1):
		to_move_pos = value
	elif looking_direction == Vector2(1,0):
		to_move_pos = value - 8*looking_direction  + Vector2(0,8)
	elif looking_direction == Vector2(-1,0):
		to_move_pos = value - 8*looking_direction  + Vector2(0,8)
	
	
	print(to_move_pos)

func set_distance_to_move():
	distance_to_move = self.global_position.distance_to(to_move_pos)/16

func move_animation():
	walk_at(looking_direction)

func move(delta):
	
	if check_distance_to_target() > 0:
		global_position = global_position.move_toward(to_move_pos,delta*move_speed)
	else:
		exclamation.visible = false
		can_move = false
		look(looking_direction)
		reached_target.emit()
		if player_spotted == true:
			start_battle()
		
func check_distance_to_target():
	if looking_direction != Vector2(0,1):
		return self.global_position.distance_to(to_move_pos)/16
	return (self.global_position.distance_to(to_move_pos)/16)
	
func start_battle():
	
	_interact()
	can_battle = false
	
