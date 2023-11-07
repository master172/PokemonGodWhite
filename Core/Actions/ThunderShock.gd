extends "res://Core/Actions/ThunderBolt.gd"


func _end():
	if target != []:
		
		target[0].stun(5)
		
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)

