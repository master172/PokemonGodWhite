extends Node
class_name SetCollisionLayerComponent


func _ready():
	var parent = get_parent()
	parent.set_collision_layer_value(1,false)
	parent.set_collision_layer_value(2,true)
	parent.set_collision_layer_value(5,true)
	
	parent.set_collision_mask_value(1,false)
