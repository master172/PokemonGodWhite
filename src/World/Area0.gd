extends Node2D
class_name MapRoom

@export_subgroup("common")
@export var common_pokemons :Array[Pokemon] = []
@export var common_relative:int = 10
@export var common_enabled:bool = true

@export_subgroup("uncommon")
@export var uncommon_pokemons :Array[Pokemon] = []
@export var uncommon_relative:int = 5
@export var uncommon_enabled:bool = true

@export_subgroup("rare")
@export var rare_pokemons :Array[Pokemon] = []
@export var rare_relative:int = 1
@export var rare_enabled:bool = true

@export_subgroup("levels")
@export var min_level :int
@export var max_level :int

@onready var rarity :Dictionary = {}

@onready var groups :Dictionary = {}

func _ready() -> void:
	initialize_groups()

func initialize_groups():
	rarity.clear()
	groups.clear()
	
	if common_enabled:
		rarity["common"] = common_relative
		groups["common"] = common_pokemons
	if rare_enabled:
		rarity["rare"] = rare_relative
		groups["rare"] = rare_pokemons
	if uncommon_enabled:
		rarity["uncommon"] = uncommon_relative
		groups["uncommon"] = uncommon_pokemons

# Called when the node enters the scene tree for the first time.
func get_encounter_pokemon():
	var index = get_group_from_rarity()
	var Rng = RandomNumberGenerator.new()
	if index != null:
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
		if group_index <= running_total:
			print("rarity group: ", i)
			return groups[i]
			
func calculate_total_relative():
	var total:int = 0
	for i in rarity:
		total += rarity[i]
	print(total)
	return total
