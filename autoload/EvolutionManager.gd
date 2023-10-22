extends Node

@export var pokemon_to_evolve:Array[game_pokemon] = []
@export var evolving_pokemon :Array[Pokemon] = []

func remove_evolution_zero():
	pokemon_to_evolve.remove_at(0)
	evolving_pokemon.remove_at(0)

func evolve():
	pokemon_to_evolve[0].evolve(evolving_pokemon[0])
	remove_evolution_zero()
