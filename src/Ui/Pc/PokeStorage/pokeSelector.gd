extends TextureRect

const normal_sprite = preload("res://assets/player/ash/Bag/pokeselector.png")
const active_sprite = preload("res://assets/player/ash/Bag/pokeselector1.png")

var active:bool = false

var pokemon:game_pokemon

@export_range(0,5) var slot_no:int = 0

func ready():
	if AllyPokemon.get_Party_pokemon_size() > slot_no:
		pokemon = AllyPokemon.get_party_pokemon(slot_no)
		update()

func update():
	pass
	
func change_selected(a:bool):
	active = a

func change_sprite():
	if active == true:
		texture = active_sprite
		return
	texture = normal_sprite

func get_pokename():
	return pokemon.Nick_name
