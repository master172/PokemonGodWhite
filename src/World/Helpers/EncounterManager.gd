extends Node
class_name encounterManager

@export_subgroup("land pokemons")
@export_subgroup("common")
@export var common_pokemons :Array[Pokemon] = []
@export var common_relative:int = 10
@export var common_enabled:bool = true

@export_subgroup("uncommon")
@export var uncommon_pokemons :Array[Pokemon] = []
@export var uncommon_relative:int = 5
@export var uncommon_enabled:bool = false

@export_subgroup("rare")
@export var rare_pokemons :Array[Pokemon] = []
@export var rare_relative:int = 1
@export var rare_enabled:bool = true

@export_subgroup("levels")
@export var min_level :int
@export var max_level :int


@export_subgroup("encounter_rate")
@export var EncounterRate:int = 7

@export var map:int =1

@onready var rarity :Dictionary = {
	"rare":rare_relative,
	"common":common_relative,
}

@onready var groups :Dictionary = {
	"rare":rare_pokemons,
	"common":common_pokemons
}



func _ready():
	initialize_groups()
	var player = Utils.get_player()
	if player != null:
		player.connect("player_stopped_signal",check_encounter)

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

func check_encounter():
	if Utils.can_encounter == true and Utils.get_player().is_surfing == false:
		if Utils.get_scene_manager() != null:
			if encounter() == true:
				var Rng = RandomNumberGenerator.new()
				var pokemon = [get_encounter_pokemon(),Rng.randi_range(min_level,max_level),]
				if pokemon == null:
					return
				if talisman_attuned(pokemon):
					return
				var pokemon_to_encounter = game_pokemon.new(pokemon[0],pokemon[1])
				BattleManager.current_ai_level = 0
				Utils.get_scene_manager().transition_to_battle_scene(pokemon_to_encounter,map)
				Utils.get_player().change_animation(false)

func talisman_attuned(pokemon:game_pokemon) -> bool:
	if Utils.talisman_active == false:
		return false
	var level:int = 0
	for i :game_pokemon in AllyPokemon.get_party_pokemons():
		level += i.level

	if level >= pokemon.level:
		return true

	return false

func encounter():
	var Rng = RandomNumberGenerator.new()
	var random_encounter = Rng.randi_range(0,100)
	return random_encounter <= EncounterRate

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
		if group_index <= running_total:
			print("rarity group: ", i)
			return groups[i]

func calculate_total_relative():
	var total:int = 0
	for value in rarity.values():
		total += value
	return total
