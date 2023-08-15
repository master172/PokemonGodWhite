extends State

class_name EnemyKnockBackState

@export var User:PokeEnemy

var knockback_vector :Vector2

var knockback:Vector2 = Vector2.ZERO
var damage_strenth:int = 0
@export var knockback_modifier := 300

signal finished

func _ready():
	set_physics_process(false)
	
func _enter_state():
	set_physics_process(true)
	calculate_knockback()
	
func _exit_state():
	print("exiting state")
	set_physics_process(false)
	knockback_vector = Vector2.ZERO
	damage_strenth = 0
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO,10000*delta)
	User.velocity = knockback
	
	if knockback == Vector2.ZERO:
		emit_signal("finished")
		
func calculate_knockback():
	knockback = knockback_vector * knockback_modifier * damage_strenth

func set_variables(v1,v2):
	knockback_vector = v1
	damage_strenth = v2
