extends Node

@onready var current_pokemon:game_pokemon = AllyPokemon.get_main_pokemon()

func add_debug_party():
	var ralts = load("res://Core/Pokemon/Ralts.tres")
	var Ralts:game_pokemon = game_pokemon.new(ralts,5,"Beta",1)
	
	var buneary = load("res://Core/Pokemon/Buneary.tres")
	var Buneary:game_pokemon = game_pokemon.new(buneary,5,"Gamma",1)
	
	var fennekin = load("res://Core/Pokemon/Fennekin.tres")
	var Fennekin:game_pokemon = game_pokemon.new(fennekin,5,"Zeta",1)
	
	var gible = load("res://Core/Pokemon/Gible.tres")
	var Gible:game_pokemon = game_pokemon.new(gible,5,"Eta",1)
	
	var riolu = load("res://Core/Pokemon/Riolu.tres")
	var Riolu:game_pokemon = game_pokemon.new(riolu,5,"Epsilon",1)
	
	var pidgey = load("res://Core/Pokemon/Pidgey.tres")
	var Pidgey:game_pokemon = game_pokemon.new(pidgey,17,"Nu",1)
	
	var pidgeotto = load("res://Core/Pokemon/Pidgeotto.tres")
	var Pidgeotto:game_pokemon = game_pokemon.new(pidgeotto,5,"Theta",1)
	
	
	AllyPokemon.add_pokemon(Ralts)
	AllyPokemon.add_pokemon(Buneary)
	AllyPokemon.add_pokemon(Fennekin)
	AllyPokemon.add_pokemon(Gible)
	AllyPokemon.add_pokemon(Riolu)
	AllyPokemon.add_pokemon(Pidgeotto)
	AllyPokemon.add_pokemon(Pidgey)
	
	return "added debug party"

func hello():
	return "Hello World"

func can_encounter(value:bool) ->String:
	Utils.can_encounter = value
	return "set encounters to "+str(value)

func developer_mode(value:bool) -> String:
	Utils.developer_mode = value
	return "set developer mode to "+str(value)

func set_pokemon(Name:String):
	current_pokemon = AllyPokemon.find_pokemon_by_name(Name)
	return "current pokemon is " + current_pokemon.Nick_name
	
func level_up(pokemon:String = ""):
	if pokemon != "":
		set_pokemon(pokemon)
	current_pokemon.recive_experience_points(current_pokemon.exp_to_next_level-current_pokemon.exp)
	return "leveled " + current_pokemon.Nick_name + " up"

func full_exp(pokemon:String = ""):
	if pokemon != "":
		set_pokemon(pokemon)
	current_pokemon.recive_experience_points((current_pokemon.exp_to_next_level-current_pokemon.exp) - 1 )
	return "gave full experience to " + current_pokemon.Nick_name

func set_pokemon_by_num(num:int):
	current_pokemon = AllyPokemon.get_party_pokemon(num)
	return "current pokemon is " + current_pokemon.Nick_name

func all_heal():
	AllyPokemon.all_heal()
	return "healed all pokemon"

func save():
	Utils.get_scene_manager().shoot_screen()
	Utils.save_data(false)
	return "saved game"
