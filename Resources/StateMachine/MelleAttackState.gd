extends State
class_name MelleAttackState

@export var actor:PokeEnemy

func _enter_state():
	print("attack")
	await get_tree().create_timer(0.1).timeout
	actor.velocity = Vector2.ZERO
