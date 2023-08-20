extends State
class_name StallState

@export var actor:PokeEnemy

func _enter_state():
	actor.velocity = Vector2.ZERO

func _exit_state():
	pass
