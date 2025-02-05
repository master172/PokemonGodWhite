extends looking_trainer
class_name spinning_trainer

@export var timer:Timer
@export var spin_time:int = 2
@export var spin_noise:int = 1
@export var can_look:bool = true

@export_group("directions")
@export var up:bool = true
@export var left:bool = true
@export var down:bool = true
@export var right:bool = true

@onready var RNG = RandomNumberGenerator.new()

var avialaible_directions:Array = []

func set_directions() -> void:
	if up == true:
		avialaible_directions.append(Vector2(0,-1))
	if down == true:
		avialaible_directions.append(Vector2(0,1))
	if left == true:
		avialaible_directions.append(Vector2(-1,0))
	if right == true:
		avialaible_directions.append(Vector2(1,0))

func spinning_set() -> void:
	set_directions()
	timer.one_shot = true
	RNG.randomize()
	set_spin_time()
	timer.start()
	timer.timeout.connect(spin)

func set_spin_time():
	var spin_additive = rng.randi_range(-spin_noise,spin_noise)
	timer.wait_time = spin_time + spin_additive
	
func spin():
	if player_spotted == false:
		looking_direction = avialaible_directions[RNG.randi() % avialaible_directions.size()]
				
		var trainer_visible
		look(looking_direction)
		
		if can_look:
			
			set_line_of_sight()
			await get_tree().create_timer(0.1).timeout
			check()
			
		
		timer.start()
	

func _process(delta: float) -> void:
	pass
