extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_scene(scene:PackedScene):
	var Scene = scene.instantiate()
	add_child(Scene)
	Utils.set_player()

