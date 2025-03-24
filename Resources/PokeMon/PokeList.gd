extends Resource

class_name Poke_list

@export var Name:String = ""
@export var pokemons:Array[game_pokemon]

signal can_start_move_learner

func add_pokemon(Game_pokemon:game_pokemon):
	pokemons.append(Game_pokemon)

func remove_pokemon(index:int):
	pokemons.remove_at(index)

func Erase_pokemon(pokemon:game_pokemon):
	pokemons.erase(pokemon)
	
func get_pokemons():
	if pokemons.size() >= 1:
		return pokemons
	else:
		return null

func set_pokemon(num:int,pokemon:game_pokemon):
	if num >= 0 and num < pokemons.size():
		pokemons[num] = pokemon
		
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

func find_pokemon_by_name(Nick_Name:String):
	if Nick_Name == "":
		return null
	for i in pokemons:
		if i.Nick_name == Nick_Name:
			return i

func erase_pokemon(num:int):
	pokemons.remove_at(num)
