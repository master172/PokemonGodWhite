extends Node2D

signal has_modulate
signal no_modulate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_scene(scene:PackedScene):
	var Scene = scene.instantiate()
	if Scene.has_meta("Modulate"):
		if Scene.get_meta("Modulate") == true:
			emit_signal("has_modulate")
		else:
			emit_signal("no_modulate")
	else:
		emit_signal("no_modulate")
		
	add_child(Scene)
	
	
	await get_tree().create_timer(0.1).timeout
