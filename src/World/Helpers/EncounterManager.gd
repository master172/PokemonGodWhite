extends Node2D

@export_subgroup("land pokemons")
@export_subgroup("common")
@export var common_pokemons :Array[Pokemon] = []
@export var common_relative:int = 10

@export_subgroup("rare")
@export var rare_pokemons :Array[Pokemon] = []
@export var rare_relative:int = 1

@export_subgroup("levels")
@export var min_level :int
@export var max_level :int

@export_subgroup("encounter_rate")
@export var EncounterRate:int = 7
@onready var rarity :Dictionary = {
	"rare":rare_relative,
	"common":common_relative,
}

@onready var groups :Dictionary = {
	"rare":rare_pokemons,
	"common":common_pokemons
}



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
	
func encounter():
	var Rng = RandomNumberGenerator.new()
	Rng.randomize()
	var random_encounter = randi_range(0,100)
	if random_encounter <= EncounterRate:
		return true
	
	return false

func get_encounter_pokemon():
	var index = get_group_from_rarity()
	var Rng = RandomNumberGenerator.new()
	var pokemon = index[Rng.randi() % index.size()]
	return pokemon

func get_group_from_rarity():
	var max_relative = calculate_total_relative()
	
	var Rng = RandomNumberGenerator.new()
	var group_index = Rng.randi_range(0,max_relative)
	
	print("group index: ",group_index)
	
	var running_total :int = 0
	for i in rarity:
		running_total += rarity[i]
		print("running total: ",running_total)
		if group_index <= running_total:
			print("rarity group: ", i)
			return groups[i]
			
func calculate_total_relative():
	var total:int = 0
	for i in rarity:
		total += rarity[i]
	print(total)
	return total
