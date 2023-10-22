extends Resource
class_name trigger

@export_enum("Level", "Stone", "Trade") var evolution_type: int = 0

@export var evolving_level:int = 16
@export var evolving_stone:EvolutionStone = null

@export var NextPokemon:Pokemon

func check_evolution(pokemon:game_pokemon):
	if evolution_type == 0:
		if pokemon.level >= evolving_level:
			append_evolution(pokemon)
			return true
		else:
			return false
	else:
		return false

func append_evolution(pokemon):
	EvolutionManager.pokemon_to_evolve.append(pokemon)
	EvolutionManager.evolving_pokemon.append(NextPokemon)
