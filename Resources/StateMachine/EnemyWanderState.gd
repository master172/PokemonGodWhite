extends State
class_name EnemyWanderState

@export var actor:PokeEnemy
@export var NavigationAgent :NavigationAgent2D

var desired_position = Vector2.ZERO



func _ready():
	set_physics_process(false)
	
	NavigationAgent.path_desired_distance = 4.0
	NavigationAgent.target_desired_distance = 4.0
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame

func _enter_state():
	create_random_position()
	set_physics_process(true)

func _exit_state():
	print("ro")

func create_random_position():
	desired_position = selection_mapping(100)
	print(desired_position)
	set_movement_target(desired_position)
	
func set_movement_target(movement_target: Vector2):
	NavigationAgent.target_position = (actor.global_position + movement_target)
	print(actor.global_position + movement_target)
	
func selection_mapping(r:int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	while true:
		var x = rng.randi_range(-r,r)
		var y = rng.randi_range(-r,r)
		if Vector2(x,y).distance_to(Vector2(0,0)) <= r:
			if actor.global_position + Vector2(x,y) >= Vector2(64,64) and actor.global_position +Vector2(x,y) <= Vector2(1128,728):
				return Vector2(x,y)
	
func wander(delta):
	if NavigationAgent.is_navigation_finished():
		create_random_position()
		
	var current_agent_position: Vector2 = actor.global_position
	var next_path_position: Vector2 = NavigationAgent.get_next_path_position()
	
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * actor.movement_speed
	actor.velocity = new_velocity

func _physics_process(delta):
	wander(delta)
