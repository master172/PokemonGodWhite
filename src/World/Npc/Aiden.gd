extends "res://src/World/Npc/Bea.gd"

@export var pokemons:Array[Pokemon]
@export var levels :Array[int]

var rng = RandomNumberGenerator.new()

func _ready():
	DialogLayer.get_child(0).function_manager.connect("battle",battle)
	

func battle():
	var pokemon = get_main_pokemon()
	Utils.get_scene_manager().transistion_trainer_battle_scene(pokemon,pokemons,levels)
	Utils.get_player().change_animation(false)

func get_main_pokemon():
	var pokemon = pokemons[0]
	var poke_data = [pokemon,levels[0]]
	return poke_data

func get_pokemon(num:int):
	var pokemon = pokemons[num]
	var poke_data = [pokemon,levels[num]]
	return poke_data
