extends State
class_name EnemyDodgeState

@export var actor:PokeEnemy = null
var player:BattlePokemon = null
@export var range_modifier :int = 1000
@export var friction :int = 5000

var dodge : Vector2 = Vector2.ZERO

signal finished

func player_set(Player):
	player = Player
	
func _ready() -> void:
	set_physics_process(false)

func _enter_state():
	dodge = get_vector_direction() * range_modifier
	set_physics_process(true)
	player = null
	
func _exit_state():
	set_physics_process(false)
	

func _physics_process(delta):
	dodge = dodge.move_toward(Vector2.ZERO,friction*delta)
	
	actor.velocity = dodge
	
	if dodge == Vector2.ZERO:
		emit_signal("finished")
		
func get_vector_direction():
	var side:int = 0
	var arr = [-1,1]
	var rng = RandomNumberGenerator.new()
	
	side = arr[rng.randi() % arr.size()]
	var dir = actor.position.direction_to(player.position)
	return dir.rotated(deg_to_rad((90 + rng.randi_range(-30,30)) * side))
