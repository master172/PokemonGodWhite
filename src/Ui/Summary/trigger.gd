extends Panel

@onready var panel = $Panel

@onready var texture_rect = $TextureRect
@onready var label = $Label

func _ready():
	panel.visible = false

func set_active(value:bool):
	if value == true:
		panel.visible = true
	else:
		panel.visible = false

func update(Trigger:trigger):
	texture_rect.texture = Trigger.NextPokemon.get_front_sprite()
	label.text = Trigger.NextPokemon.Name
