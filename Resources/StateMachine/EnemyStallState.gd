extends State
class_name StallState

@export var actor:PokeEnemy

func _enter_state():
	actor.velocity = actor.velocity * 0.001

func _exit_state():
	pass
