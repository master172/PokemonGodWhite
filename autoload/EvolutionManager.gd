extends Node

@export var pokemon_to_evolve:Array[game_pokemon] = []
@export var evolving_pokemon :Array[Pokemon] = []

@export var Evolving_pokemon:Pokemon
@export var Pokemon_to_evolve:game_pokemon

signal evolution_done

func remove_evolution_zero():
	pokemon_to_evolve.remove_at(0)
	evolving_pokemon.remove_at(0)

func evolve():
	pokemon_to_evolve[0].evolve(evolving_pokemon[0])
	manage_connections(pokemon_to_evolve[0])
	Utils.get_scene_manager().connect("evolution_finished",remove_evolution_zero())

func manage_connections(pokemon):
	var current_pokemon = pokemon
	if current_pokemon != null:
		current_pokemon.connect("learn_extra_move",learn_move)
		current_pokemon.connect("replaced_moves",learned_move)
		current_pokemon.connect("learning_process_complete",done_one_evolution)
	
func done_one_evolution():
	if PokemonManager.MovesToLearn.size() == 0:
		emit_signal("evolution_done")
		Evolving_pokemon = null
		Pokemon_to_evolve = null
	else:
		await PokemonManager.allfinished
		emit_signal("evolution_done")
		Evolving_pokemon = null
		Pokemon_to_evolve = null

func done_evolving():
	Evolving_pokemon = null
	Pokemon_to_evolve = null
	
func learn_move(pokemon,move):
	PokemonManager.Starting_dialog(pokemon,move)
	
func learned_move(pokemon:game_pokemon,prev_move:GameAction,new_move:GameAction):
	print(pokemon.Nick_name, " ", prev_move.base_action.name, " ", new_move.base_action.name)
	PokemonManager.finishing_dialog(pokemon,prev_move,new_move)
	pokemon.disconnect("learn_extra_move",learn_move)
	pokemon.disconnect("replaced_moves",learned_move)
	
