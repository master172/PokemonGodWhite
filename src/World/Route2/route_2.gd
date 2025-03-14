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

@onready var rarity :Dictionary = {
	"rare":rare_relative,
	"common":common_relative,
}

@onready var groups :Dictionary = {
	"rare":rare_pokemons,
	"common":common_pokemons
}

@onready var forestModulate = $CanvasModulate

# Called when the node enters the scene tree for the first time.
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

func get_modulater():
	return forestModulate