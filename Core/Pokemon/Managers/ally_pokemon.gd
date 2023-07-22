extends Node

@export var PartyPokemon:Poke_list

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
