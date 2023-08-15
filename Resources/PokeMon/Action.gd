extends Node2D

class_name Action

var holder:GameAction

signal attack_finished(attack)



func _ready():
	_attack()
	
func _attack():
	pass

func set_holder(node):
	holder = node
