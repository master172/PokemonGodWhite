extends Node2D

@export var parent0:game_pokemon
@export var parent1:game_pokemon

@export var product_pokemon:game_pokemon
var species:Pokemon

var RNG:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	parent0 = game_pokemon.new(load("res://Core/Pokemon/Naichi.tres"),5)
	parent1 = game_pokemon.new(load("res://Core/Pokemon/Sparkave.tres"),5)
	test()

func test():
	_breed()

func can_breed():
	if not(parent0.gender != parent1.gender and not(parent0.gender == -1 or parent1.gender ==-1)):
		return false
	if not(matching_egg_groups()):
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
		return parent0.Base_Pokemon
	else:
		return parent1.Base_Pokemon

func _breed():
	if can_breed():
		var my_egg = [true,parent0,parent1]
		var species = choose_species()
		product_pokemon = game_pokemon.new(species,5,"",-1,my_egg)
	else:
		print("same gender")
