extends Node2D

@export var parent0:game_pokemon
@export var parent1:game_pokemon

@export var product_pokemon:game_pokemon
var species:Pokemon

var RNG:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	parent0 = game_pokemon.new(load("res://Core/Pokemon/Noctichi.tres"),20)
	parent1 = game_pokemon.new(load("res://Core/Pokemon/Pidgey.tres"),20)
	_breed()

func can_breed():
	if not(parent0.gender != parent1.gender and not(parent0.gender == -1 or parent1.gender ==-1)):
		print("same gender")
		return false
	if not(matching_egg_groups()):
		print("different egg groups")
		return false
	return true

func matching_egg_groups():
	if parent0.Base_Pokemon.Egg_group0 == parent1.Base_Pokemon.Egg_group0 or parent0.Base_Pokemon.Egg_group0 == parent1.Base_Pokemon.Egg_group1:
		return true
	elif parent0.Base_Pokemon.Egg_group1 == parent1.Base_Pokemon.Egg_group0 or parent0.Base_Pokemon.Egg_group1 == parent1.Base_Pokemon.Egg_group1:
		return true
	return false
	
func choose_species():
	if RNG.randi() % 2 == 0:
		return find_base_pokemon(parent0.Base_Pokemon)
	else:
		return find_base_pokemon(parent1.Base_Pokemon)

func find_base_pokemon(pokemon:Pokemon) ->Pokemon:
	if pokemon.previous_pokemon == "":
		return pokemon
	var prev_pokemon = load(pokemon.previous_pokemon)
	
	if prev_pokemon:
		return find_base_pokemon(prev_pokemon)
	else:
		return pokemon
	
func _breed():
	if not can_breed():
		print("can't breed")
		return
	var my_egg = [true,parent0,parent1]
	var species = choose_species()
	print(species.Name)
	product_pokemon = game_pokemon.new(species,5,"",-1,my_egg)
	show_results(product_pokemon)
	
func show_results(product:game_pokemon):
	print(product_pokemon.Nick_name)
