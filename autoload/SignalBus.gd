extends Node

signal attack_finished(attack,user)
signal attack_landed(attack,User)

func attack_completed(attack,user):
	emit_signal("attack_finished",attack,user)
	
func on_attack_landed(attack,user):
	emit_signal("attack_landed",attack,user)
