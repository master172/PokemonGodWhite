extends Control

@onready var background = $Background

func _unactive():
	background.self_modulate = Color(0, 0, 0, 0)
	
func _active():
	background.self_modulate = Color(0, 0, 0, 1)
