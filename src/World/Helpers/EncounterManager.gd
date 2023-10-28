extends Node2D

@export var pokemons :Array[Pokemon]= []
@export var min_level:int = 3
@export var max_level:int = 6
@export var EncounterRate:int = 16

func _ready():
	var player = Utils.get_player()
	if player != null:
		player.connect("player_stopped_signal",check_encounter)


func check_encounter():
	if Utils.get_scene_manager() != null:
		if encounter() == true:
			var pokemon = get_encounter_pokemon()
			Utils.get_scene_manager().transistion_to_battle_scene(pokemon)
			Utils.get_player().change_animation(false)

func get_encounter_pokemon():
	var Rng = RandomNumberGenerator.new()
	var encounter_pokemon = pokemons[Rng.randi() % pokemons.size()]
	var poke_data = [encounter_pokemon,Rng.randi_range(min_level,max_level)]
	return poke_data
	
func encounter():
	var Rng = RandomNumberGenerator.new()
	Rng.randomize()
	var random_encounter = randi_range(0,100)
	if random_encounter <= EncounterRate:
		return true
	
	return false
