extends Node

@export var PartyPokemon:Poke_list = Poke_list.new()

var save_file_path = "user://save/Pokemon/"
var save_file_name = "Pokemon.tres"
# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)

func done_loading():
	if PartyPokemon.pokemon_size() >= 1:
		PartyPokemon.get_pokemon(0).calculate_stats_init()
	

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	load_data()
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_data():
	ResourceSaver.save(PartyPokemon,save_file_path + save_file_name)

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		PartyPokemon = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	done_loading()
	
	
func add_pokemon(Pokemon):
	PartyPokemon.add_pokemon(Pokemon)

func get_main_pokemon():
	var pokemons = PartyPokemon.get_pokemons()
	if pokemons != null:
		return pokemons[0]

func get_party_pokemon(num:int):
	var pokemon = PartyPokemon.get_pokemon(num)
	return pokemon

func get_Party_pokemon_size():
	return PartyPokemon.pokemon_size()

func all_fainted():
	for i in PartyPokemon.pokemons:
		if i.fainted == false:
			return false
	return true

func all_heal():
	PartyPokemon.all_heal()
