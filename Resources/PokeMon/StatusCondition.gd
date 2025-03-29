extends Node
class_name VolatileStausCondition

var Holder:CharacterBody2D

func _ready() -> void:
	self.tree_exiting.connect(remove_condition)
	add_effect()
	
func add_effect():
	pass
	
func remove_condition():
	pass
