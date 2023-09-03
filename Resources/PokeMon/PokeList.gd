extends Resource

class_name Poke_list

@export var Name:String = ""
@export var pokemons:Array[game_pokemon]

func add_pokemon(game_pokemon):
	pokemons.append(game_pokemon)

func get_pokemons():
	if pokemons.size() >= 1:
		return pokemons
	else:
		return null

func get_pokemon(num:int):
	if pokemons.size() >= num + 1:
		return(pokemons[num])
	else:
		return null

func pokemon_size():
	return pokemons.size()

func calculate_stats():
	for i in pokemons:
		i.calculate_stats()

func clear_pokemon():
	pokemons = []

func all_heal():
	for i in pokemons:
		i.heal()
