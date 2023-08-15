extends Node

signal attack_finished(attack,user)

func attack_completed(attack,user):
	emit_signal("attack_finished",attack,user)

func connect_attack_completed(attack,user):
	attack.attack_finished.connect(attack_completed.bind(attack,user))
