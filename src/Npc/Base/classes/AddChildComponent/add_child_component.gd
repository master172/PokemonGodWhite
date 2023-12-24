extends Node2D
class_name AddChildComponent

var Parent
@export var NodesToAdd:NodeList

func _ready():
	Parent = get_parent()
	add_children_to_parent()
	
func add_children_to_parent():
	if NodesToAdd != null:
		for i in NodesToAdd.Nodes:
			Parent.add_child(i.instantiate())
