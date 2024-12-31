extends looking_trainer
class_name moving_trainer

@export var MovePoints:Array[Vector2] = []
@export var current_target:int = 1

func moving_set():
	move_to(current_target)
	reached_target.connect(set_target)

func move_to(i):
	looking_direction = (MovePoints[i] - MovePoints[i-1]).normalized()
	set_line_of_sight()
	if looking_direction == Vector2(0,-1):
		handle_moving(MovePoints[i] + 16*looking_direction)
	elif looking_direction == Vector2(0,1):
		handle_moving(MovePoints[i])
	elif looking_direction == Vector2(1,0):
		handle_moving(MovePoints[i] + 8*looking_direction  - Vector2(0,8))
	elif looking_direction == Vector2(-1,0):
		handle_moving(MovePoints[i] + 8*looking_direction  - Vector2(0,8))
	
func set_target():
	if player_spotted == false:
		print("reached")
		current_target = (current_target + 1) % MovePoints.size()
		move_to(current_target)

func _physics_process(delta: float) -> void:
	super(delta)
	if player.is_moving == true:
		await player.player_stopped_signal
		
	check()
