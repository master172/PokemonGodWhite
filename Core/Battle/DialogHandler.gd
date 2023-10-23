extends Node


@export var won_dialog:DialogueLine
@export var won_dialog_level_up:DialogueLine
@export var lost_match:DialogueLine
@export var lost_battle:DialogueLine
@export var run_dialog:DialogueLine
@export var moveLearned_dialog:DialogueLine
@export var PokemonCaught:DialogueLine

@onready var Temp_won_dialog:DialogueLine = won_dialog
@onready var Temp_won_dialog_level_up:DialogueLine = won_dialog_level_up
@onready var Temp_lost_match:DialogueLine = lost_match
@onready var Temp_lost_battle:DialogueLine = lost_battle
@onready var Temp_run_dialog:DialogueLine = run_dialog
@onready var Temp_moveLearned_dialog:DialogueLine = moveLearned_dialog
@onready var Temp_PokemonCaught:DialogueLine = PokemonCaught

signal next_pokemon
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	DialogLayer.get_child(0).connect("finished",on_won_dialog_finished)
	DialogLayer.get_child(0).connect("finished",on_lost_battle_finished)
	DialogLayer.get_child(0).connect("finished",on_lost_match_finished)
	DialogLayer.get_child(0).connect("finished",_run_finished)
	DialogLayer.get_child(0).connect("finished",_move_learned_finished)
	DialogLayer.get_child(0).connect("finished",_pokemon_caught_finished)
	
func add_won_dialog(pokemon:game_pokemon,winner:game_pokemon):
	
	
	won_dialog.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	won_dialog.add_symbols_to_replace({"Winner":winner.Nick_name})
	won_dialog.add_symbols_to_replace({"points":str(pokemon.calculate_experience_points())})
	
	DialogLayer.get_child(0)._start(won_dialog)


func add_won_dialog_level_up(pokemon:game_pokemon,winner:game_pokemon):
	won_dialog_level_up.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	won_dialog_level_up.add_symbols_to_replace({"Winner":winner.Nick_name})
	won_dialog_level_up.add_symbols_to_replace({"points":str(pokemon.calculate_experience_points())})
	won_dialog_level_up.add_symbols_to_replace({"level":str(winner.level)})
	DialogLayer.get_child(0)._start(won_dialog_level_up)
	
	
func on_won_dialog_finished(dialog):
	
	if dialog == won_dialog or dialog == won_dialog_level_up:
		if BattleManager.EnemyPokemons.size() > 0:
			BattleManager.EnemyPokemons.remove_at(0)
		if BattleManager.EnemyLevels.size() > 0:
			BattleManager.EnemyLevels.remove_at(0)
		check_move_learned()

func battle_pokemon_defeated(pokemon):
	if AllyPokemon.all_fainted() == true:
		Lost_battle(pokemon)
	else:
		Lost_match(pokemon)

func Lost_battle(pokemon):
	print(pokemon.Nick_name)
	lost_battle = lost_battle.duplicate()
	lost_battle.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	DialogLayer.get_child(0)._start(lost_battle)
	

func on_lost_battle_finished(dialog):
	if dialog == lost_battle:
		Utils.get_scene_manager().transistion_exit_battle_scene()
		AllyPokemon.all_heal()
	
func Lost_match(pokemon):
	print(pokemon.Nick_name)
	lost_match.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	DialogLayer.get_child(0)._start(lost_match)
	

func on_lost_match_finished(dialog):
	pass
	
func _run():
	DialogLayer.get_child(0)._start(run_dialog)
	

func _run_finished(dialog):
	if dialog == run_dialog:
		Utils.get_scene_manager().transistion_exit_battle_scene()

func start_move_learning():
	PokemonManager.connect("allfinished",check_move_learned)
	PokemonManager._start_move_learning()

func check_move_learned():
	if PokemonManager.movesLearned.size() > 0:
		move_learned()
	else:
		if PokemonManager.MovesToLearn.size() > 0:
			start_move_learning()
		else:

			if BattleManager.EnemyPokemons.size() == 0:
				won_dialog = Temp_won_dialog
				won_dialog_level_up = Temp_won_dialog_level_up
				lost_match = Temp_lost_match
				lost_battle = Temp_lost_battle
				run_dialog = Temp_run_dialog
				moveLearned_dialog = Temp_moveLearned_dialog
				PokemonCaught = Temp_PokemonCaught
				Utils.get_scene_manager().transistion_exit_battle_scene()

			else:
				emit_signal("next_pokemon")
func move_learned():
	moveLearned_dialog.add_symbols_to_replace({"Pokemon":PokemonManager.movesLearned[0].pokemon.Nick_name})
	moveLearned_dialog.add_symbols_to_replace({"Move":PokemonManager.movesLearned[0].move.action.name})
	DialogLayer.get_child(0)._start(moveLearned_dialog)
	

func _move_learned_finished(dialog):
	if dialog == moveLearned_dialog:
		PokemonManager.movesLearned.remove_at(0)
		moveLearned_dialog.remove_all_symbols()
		check_move_learned()

func pokemon_caught(pokemon:game_pokemon):
	PokemonCaught.add_symbols_to_replace({"pokemon":pokemon.Nick_name})
	DialogLayer.get_child(0)._start(PokemonCaught)
	

func _pokemon_caught_finished(dialog):
	if dialog == PokemonCaught:
		Utils.get_scene_manager().transistion_exit_battle_scene()
