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

var position_to_move

func _ready():
	basic_set()
	looking_set()

func looking_set():
	if exclamation != null:
		exclamation.visible = false
	
	player = Utils.get_player()
	if LineOfSight != null:
		LineOfSight.target_position = (look_distance * 16) * looking_direction
	
	
	if player != null:
		player.connect("player_stopped_signal",check)
	
func check():
	if exclamation != null and can_battle == true:
		if not LineOfSight.is_colliding():
			exclamation.visible = false
		else:
			exclamation.visible = true
			handle_moving()
	
func handle_moving():
	can_move = true
	
	
	set_to_move(LineOfSight.get_collision_point())
	set_distance_to_move()
	move_animation()
	position_to_move = position + (distance_to_move*(looking_direction * 16))
	print(distance_to_move)
	print((distance_to_move*(looking_direction * 16)))
	
	player.stop()
	player.stop_animation()
	
	
func _physics_process(delta):
	if can_move == true:
		move(delta)
		
func set_to_move(value:Vector2):
	if looking_direction == Vector2(0,-1):
		to_move_pos = value - 16*looking_direction + Vector2(0,8)
	elif looking_direction == Vector2(0,1):
		to_move_pos = value  + Vector2(0,8)
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
	
	if check_distance_to_player() > 0:
		global_position = global_position.move_toward(position_to_move,delta*move_speed)
	else:
		exclamation.visible = false
		can_move = false
		look(looking_direction)
		start_battle()
		
func check_distance_to_player():
	if looking_direction != Vector2(0,1):
		return self.global_position.distance_to(to_move_pos)/16
	return (self.global_position.distance_to(to_move_pos-Vector2(0,8))/16)
func start_battle():
	
	_interact()
	can_battle = false
	
