extends Node2D
@onready var background = $Background
@onready var sprite = $Sprite

@export var slot_no:int = 0
var pokemon:Pokemon = null
func change_selected(value:bool):
	if value == true:
		background.frame = 1
	else:
		background.frame = 0

func _ready():
	if AllyPokemon.get_party_pokemon(slot_no) != null:
		pokemon = AllyPokemon.get_party_pokemon(slot_no)
		update_items()
	else:
		clear_items()
		
func update_items():
	sprite.texture = pokemon.get_icon()

func clear_items():
	self.visible = false
