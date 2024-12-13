extends Resource

class_name pokeSheet

@export var pokemon:Pokemon
@export_range(0, 100) var rate: int

func get_rate():
	return rate

func get_pokemon():
	return pokemon
