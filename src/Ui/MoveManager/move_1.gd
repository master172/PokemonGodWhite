extends TextureRect

var index:int = 0
var pokemon:game_pokemon

@onready var label = $Label

const active_texture = preload("res://assets/player/ash/Bag/pokeselector1.png")
const normal_texture = preload("res://assets/player/ash/Bag/pokeselector.png")
var active:bool = false

func _ready():
	update_seleceted()
	update()

func update():
	if pokemon != null:
		label.text = pokemon.get_learned_attack_name(index)
		
func set_active(value:bool):
	active = value
	update_seleceted()
	
func update_seleceted():
	if active == true:
		texture = active_texture
	else:
		texture = normal_texture
