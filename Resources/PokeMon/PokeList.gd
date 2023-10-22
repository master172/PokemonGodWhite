extends Resource

class_name Poke_list

@export var Name:String = ""
@export var pokemons:Array[game_pokemon]

signal can_start_move_learner

@export var learning_counter:int = 0

func add_pokemon(Game_pokemon:game_pokemon):
	Game_pokemon.connect("learning_process_complete",add_learned)
	pokemons.append(Game_pokemon)

func remove_pokemon(index:int):
	pokemons[index].disconnect("learning_process_complete",add_learned)
	pokemons.remove_at(index)
	
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

func add_learned():
	learning_counter += 1
	all_learned()
	
	
func all_learned():
	if learning_counter == pokemon_size():
		emit_signal("can_start_move_learner")
		learning_counter = 0

func erase_pokemon(num:int):
	pokemons.remove_at(num)
