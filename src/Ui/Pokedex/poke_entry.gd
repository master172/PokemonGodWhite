extends Control
@onready var icon = $HBoxContainer/Icon
@onready var label = $HBoxContainer/Label
@onready var panel = $Panel

var selected_color = "b7ffd9"
var regular_color = "ffffff"
var pokemon:Pokemon = null
var selected:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if pokemon != null:
		icon.texture = pokemon.get_front_sprite()
		label.text = pokemon.Name

func set_selected(value:bool):
	selected = value
	if value == true:
		panel.self_modulate = selected_color
	else:
		panel.self_modulate = regular_color

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
