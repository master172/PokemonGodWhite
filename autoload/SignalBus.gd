extends Node

signal attack_finished(attack,user)
signal attack_landed(attack,User)

func attack_completed(attack,user):
	emit_signal("attack_finished",attack,user)

func connect_attack_completed(attack,user):
	attack.attack_finished.connect(attack_completed.bind(attack,user))

func connect_attack_landed(attack,User):
	attack.attack_landed.connect(on_attack_landed.bind(attack,User))

func on_attack_landed(attack,user):
	emit_signal("attack_landed",attack,user)
