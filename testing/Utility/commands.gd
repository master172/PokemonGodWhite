extends Node


var default_pokemon_path = "res://Core/Pokemon/"


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

func say_hello():
	return "Hello, World!"

func can_encounter(value:bool) ->String:
	Utils.can_encounter = value
	return "set encounters to "+str(value)

func developer_mode(value:bool) -> String:
	Utils.developer_mode = value
	return "set developer mode to "+str(value)

func set_pokemon(Name:String):
	current_pokemon = AllyPokemon.find_pokemon_by_name(Name)
	return "current pokemon is " + current_pokemon.Nick_name

func level_up(pokemon:String = "",times:int = 1):
	if pokemon != "":
		set_pokemon(pokemon)
	for i in range(times):
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

func save(debug:bool = false):
	if debug == false:
		Utils.get_scene_manager().shoot_screen()
		Utils.save_data(false)
	else:
		AllyPokemon.save_data()
	return "saved game"

func set_position(x:int,y:int):
	var player :CharacterBody2D = Utils.get_player()
	if player != null:
		player.global_position = Vector2(x,y)
		
		return "set player position to " + str(player.global_position)
	return "[color=red]player not found[/color]"

func move_position(x:int,y:int):
	var player :CharacterBody2D = Utils.get_player()
	if player != null:
		player.global_position += Vector2(x*16,y*16)
		
		return "move player to " + str(player.global_position)
	return "[color=red]player not found[/color]"

func change_scene(scene_path:String,spawn_location:Vector2,spawn_dir:Vector2):
	var SceneManager = Utils.get_scene_manager()
	if not ResourceLoader.exists(scene_path):
		return "[color=red]Invalid Scene Path[/color]"
	if SceneManager == null:
		return "[color=red]scene manager not found[/color]"
	Utils.get_scene_manager().transition_to_scene(scene_path,spawn_location,spawn_dir)
	return "[color=green]Succesfully changed scene[/color]"

func set_bus_volume(bus_name:String,value:float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	return "change volueme to " + str(AudioServer.get_bus_volume_db(bus_index)) + " db"

func set_time_scale(val:float):
	Engine.set_time_scale(val)
	return "set time scale to " + str(Engine.get_time_scale())

func reload():
	get_tree().reload_current_scene()

func quit():
	get_tree().quit()

func add_pokemon(Name:String,level:int = 5, NickName:String = "",gender:int = -1):
	var pokemon_refrence = find_pokemon_by_path(Name)
	if not pokemon_refrence:
		return "Invalid Request"
	var pokemon = load(pokemon_refrence)
	if not pokemon:
		return "pokemon not found"
	AllyPokemon.add_pokemon(game_pokemon.new(pokemon,level,NickName,gender))
	return "pokemon sucessfully added"
	
func find_pokemon_by_path(Name:String = "",path:String = default_pokemon_path):
	var dir = DirAccess.open(path)
	if not dir:
		return null
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
		if not file_name.ends_with(".tres"):
			file_name = dir.get_next()
			continue
		if Name == "" or not file_name.get_basename().to_lower() == Name.to_lower():
			file_name = dir.get_next()
			continue
		return path+file_name
		file_name = dir.get_next()
		
	return null
	
