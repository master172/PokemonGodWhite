extends Control

@onready var number = $TextureRect/Panel/HBoxContainer/Image/Number
@onready var Name = $TextureRect/Panel/HBoxContainer/Image/Name
@onready var tag = $TextureRect/Panel/HBoxContainer/Image/Tag
@onready var types = $TextureRect/Panel/HBoxContainer/Image/Types
@onready var description = $TextureRect/Panel/HBoxContainer/Image/Description

@onready var image = $TextureRect/Panel/HBoxContainer/ImageContainer/Image
@onready var height = $TextureRect/Panel/HBoxContainer/ImageContainer/VBoxContainer/Height
@onready var weight = $TextureRect/Panel/HBoxContainer/ImageContainer/VBoxContainer/Weight

signal closed

func _set_details(pokemon:Pokemon):
	number.text = str(pokemon.Id)
	Name.text = pokemon.Name
	tag.text = pokemon.Tag
	types.text =  str(pokemon.get_Type1()+ " / "+ pokemon.get_Type2())
	description.text = pokemon.description
	image.texture = pokemon.get_front_sprite()
	height.text = str(pokemon.height)
	weight.text = str(pokemon.weight)

func _input(event):
	if event.is_action_pressed("No"):
		await get_tree().create_timer(0.1).timeout
		if visible == true:
			visible = false
			closed.emit()
