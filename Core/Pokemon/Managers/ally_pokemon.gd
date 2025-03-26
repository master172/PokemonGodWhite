extends Node

@export var PartyPokemon:Poke_list = Poke_list.new()
@export var PcPokemon:Poke_list = Poke_list.new()

var save_file_path = "user://save/Pokemon/"
var save_file_name = "Pokemon.tres"

var PC_save_file_path = "user://save/Pokemon/"
var PC_save_file_name = "PC_Pokemon.tres"
# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)

func done_loading():
	if PartyPokemon.pokemon_size() >= 1:
		for i in PartyPokemon.get_pokemons():
			i.calculate_stats_init()
	if get_pcPokemonSize() >= 1:
		for i in PcPokemon.get_pokemons():
			i.calculate_stats_init()
	
func trade_pokemon(set_pokemon_index:int,pokemon:game_pokemon):
	set_pokemon(set_pokemon_index,pokemon.duplicate())
	get_party_pokemon(set_pokemon_index).set_trade_done(true)
	get_party_pokemon(set_pokemon_index).check_evolution()
	save_data()

func wonder_gift_open(poke:game_pokemon):
	add_pokemon(poke.duplicate())
	poke.set_trade_done(true)
	poke.check_evolution()
	save_data()
	
func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	load_data()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_data():
	ResourceSaver.save(PartyPokemon,save_file_path + save_file_name)
	ResourceSaver.save(PcPokemon,PC_save_file_path+PC_save_file_name)
	
func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		PartyPokemon = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	if FileAccess.file_exists(PC_save_file_path+PC_save_file_name):
		PcPokemon = ResourceLoader.load(PC_save_file_path+PC_save_file_name).duplicate(true)

	done_loading()
	
	
func add_pokemon(pokemon):
	if PartyPokemon.pokemon_size() <= 5:
		PartyPokemon.add_pokemon(pokemon)
	else:
		PcPokemon.add_pokemon(pokemon)

func get_main_pokemon():
	var pokemons = PartyPokemon.get_pokemons()
	if pokemons != null:
		return pokemons[0]

func get_party_pokemon(num:int):
	var pokemon = PartyPokemon.get_pokemon(num)
	return pokemon

func set_pokemon(num:int,pokemon:game_pokemon):
	PartyPokemon.set_pokemon(num,pokemon)
	
func get_Party_pokemon_size():
	return PartyPokemon.pokemon_size()

func get_party_pokemons():
	return PartyPokemon.pokemons
	
func all_fainted():
	for i in PartyPokemon.pokemons:
		if i.fainted == false:
			return false
	return true

func all_heal():
	PartyPokemon.all_heal()

func switch_party_pokemon(index1: int, index2: int):
	var temp = PartyPokemon.pokemons[index1]
	
	PartyPokemon.pokemons[index1] = PartyPokemon.pokemons[index2]
	
	PartyPokemon.pokemons[index2] = temp

func get_PcPokemons():
	return PcPokemon.get_pokemons()

func get_pcPokemonSize():
	if PcPokemon.pokemons != null:
		return PcPokemon.pokemon_size()
	return 0

func get_pcPokemon(num:int):
	var pokemon = PcPokemon.get_pokemon(num)
	return pokemon
	
func deposit(poke_number:int):
	if get_Party_pokemon_size() > 1:
		
		var temp = PartyPokemon.get_pokemon(poke_number)
		
		PcPokemon.add_pokemon(temp)
		
		PartyPokemon.erase_pokemon(poke_number)
		
func withdraw(num:int):
	if get_Party_pokemon_size() < 6:
		var temp = PcPokemon.get_pokemon(num)
		PcPokemon.erase_pokemon(num)
		PartyPokemon.add_pokemon(temp)

func erase_party_pokemon(num:int):
	if num == -1:
		return
	PartyPokemon.erase_pokemon(num)
	
func Pc2Party_pokemon_switch(index1: int, index2: int):
	var temp = PartyPokemon.pokemons[index1]
	
	PartyPokemon.pokemons[index1] = PcPokemon.pokemons[index2]
	
	PcPokemon.pokemons[index2] = temp

func check_evolution_all():
	for i in PartyPokemon.get_pokemons():
		i.check_evolution()
	Utils.get_scene_manager().check_evolution()

func remove_data():
	if DirAccess.dir_exists_absolute("user://save/Pokemon/"):
		var dir = DirAccess.open("user://save/Pokemon/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		
	PartyPokemon = Poke_list.new()
	PcPokemon = Poke_list.new()

func battle_end():
	for i in PartyPokemon.pokemons:
		i.reset_stages()

func find_pokemon_by_name(Name:String):
	return PartyPokemon.find_pokemon_by_name(Name)
