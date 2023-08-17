extends State
class_name EnemyIdleState

signal done
@export var User:PokeEnemy

@export var timer:Timer

func _ready():
	timer.timeout.connect(idle_done)
	
func _enter_state():
	User.velocity = Vector2(0,0)
	var rng = RandomNumberGenerator.new()
	timer.start(rng.randi_range(5,7))
	

func idle_done():
	emit_signal("done")
