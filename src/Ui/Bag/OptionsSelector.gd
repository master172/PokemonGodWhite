extends Control

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var NameAddition := ""

var active:bool = false

func _ready():
	label.text = self.name + " " + NameAddition
	change()
	
func _set_active(val:bool):
	active = val
	change()
	
func change():
	if active == true:
		texture_rect.self_modulate = Color(0, 0, 0)
	else:
		texture_rect.self_modulate = Color(1, 1, 1)
