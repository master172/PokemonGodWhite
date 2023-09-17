extends Control

@export var active = false

@onready var texture_rect = $TextureRect

# Called when the node enters the scene tree for the first time.

func _set_active(val:bool):
	active = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture_rect.visible = active
