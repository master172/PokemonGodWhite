class_name EnemyFollowState
extends State

@export var actor: PokeEnemy
@export var NavigationAgent :NavigationAgent2D

signal close_to
signal next_to

var target

var chasing = false

func _ready() -> void:
	set_physics_process(false)


func actor_setup():
	await get_tree().physics_frame

func set_target(node):
	target = node

func _enter_state() -> void:
	set_physics_process(true)
	NavigationAgent.path_desired_distance = 4.0
	NavigationAgent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")
	chasing = true
	
func _exit_state() -> void:
	chasing = false
	set_physics_process(false)
	
	actor.velocity = actor.velocity * 0.001
	
func _physics_process(delta) -> void:
	if actor.targetPokemon != null:
		set_target(actor.targetPokemon)
	
	if chasing == true:
		if target != null:
			NavigationAgent.target_position = target.global_position
			if NavigationAgent.is_navigation_finished():
				return
			
			if actor.can_attack == true:
				if actor.global_position.distance_to(actor.targetPokemon.global_position) <= 400:
					emit_signal("close_to")
				
				if actor.global_position.distance_to(actor.targetPokemon.global_position) <= 200:
					emit_signal("next_to")
				
			var current_agent_position: Vector2 = actor.global_position
			var next_path_position: Vector2 = NavigationAgent.get_next_path_position()
			
			actor.velocity = current_agent_position.direction_to(next_path_position) * actor.movement_speed
			
	else:
		actor.velocity = actor.velocity * 0.001
