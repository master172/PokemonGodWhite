extends looking_trainer
class_name spinning_trainer

@export var timer:Timer
@export var spin_time:int = 2
@export var spin_noise:int = 1
@export var can_look:bool = true
@onready var RNG = RandomNumberGenerator.new()

func spinning_set() -> void:
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
		var direction:int = RNG.randi() % 4
		
		match direction:
			0:
				looking_direction = Vector2(0,1)
			1:
				looking_direction = Vector2(0,-1)
			2:
				looking_direction = Vector2(1,0)
			3:
				looking_direction = Vector2(-1,0)
				
		var trainer_visible
		look(looking_direction)
		
		if can_look:
			
			set_line_of_sight()
			await get_tree().create_timer(0.1).timeout
			check()
			
		
		timer.start()
	

func _process(delta: float) -> void:
	pass
