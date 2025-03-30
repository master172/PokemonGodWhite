extends EnemyWanderState
class_name EnemyRetreatState

@export var angle_variation:float = 45
@export var distance :float = 200
@export var rect_timer:Timer

const BOUNDARY_RECT = Rect2(Vector2(0, 0), Vector2(1200, 800))
const max_time:float = 5.0

func _ready() -> void:
	rect_timer.timeout.connect(_on_rect_timer_timeout)
	
	
func _enter_state():
	print_debug("entering retreat state")
	create_random_position()
	set_physics_process(true)
	rect_timer.start(max_time)
	
func create_random_position():
	desired_position = get_retreat_position(actor.targetPokemon)
	print(desired_position)
	set_movement_target(desired_position)
	

func get_retreat_position(danger_source: Node2D) -> Vector2:
	var direction = (actor.global_position - danger_source.global_position).normalized()
	print(direction)
	var angle_offset = deg_to_rad(randf_range(-angle_variation, angle_variation))
	var rotated_direction = direction.rotated(angle_offset)
	var retreat_position = actor.global_position + rotated_direction * distance
	retreat_position.x = clamp(retreat_position.x, BOUNDARY_RECT.position.x, BOUNDARY_RECT.end.x)
	retreat_position.y = clamp(retreat_position.y, BOUNDARY_RECT.position.y, BOUNDARY_RECT.end.y)
	return retreat_position

func set_movement_target(movement_target: Vector2):
	NavigationAgent.target_position = movement_target
	print(movement_target)
	

func wander(delta):
	if NavigationAgent.is_navigation_finished():
		emit_signal("state_finished")
		
	var current_agent_position: Vector2 = actor.global_position
	var next_path_position: Vector2 = NavigationAgent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * actor.movement_speed
	actor.velocity = new_velocity
	
func _on_rect_timer_timeout():
	print_debug("wander state timeout")
	emit_signal("state_finished")
