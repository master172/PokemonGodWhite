extends State
class_name EnemyIdleState

signal done
@export var User:PokeEnemy

@export var timer:Timer

func _ready():
	timer.timeout.connect(idle_done)
	
func _enter_state():
	print_debug("entring idle state")
	User.velocity *= 0.0001
	var rng = RandomNumberGenerator.new()
	timer.start(rng.randi_range(1.2,2.3))
	

func idle_done():
	print_debug("exiting idle state")
	emit_signal("done")
