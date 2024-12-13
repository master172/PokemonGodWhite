extends Node

@export var moveLearned_dialog:DialogueLine
@export var PokemonCaught:DialogueLine

signal next_pokemon
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready():
	Dialogic.connect("signal_event",on_won_dialog_finished)
	Dialogic.connect("signal_event",on_lost_battle_finished)
	Dialogic.connect("signal_event",on_lost_match_finished)
	Dialogic.connect("signal_event",_run_finished)
	DialogLayer.get_child(0).connect("finished",_move_learned_finished)
	Dialogic.connect("signal_event",_pokemon_caught_finished)
	
func add_won_dialog(pokemon:game_pokemon,winner:game_pokemon):
	
	Dialogic.VAR.Battle.Winner = winner.Nick_name
	Dialogic.VAR.Battle.Loser = pokemon.Nick_name
	Dialogic.VAR.Battle.Points = str(pokemon.calculate_experience_points())
	
	print_debug(winner.Nick_name, " ", pokemon.Nick_name, " ", str(pokemon.calculate_experience_points()))
	Dialogic.start('WinNormal')


func add_won_dialog_level_up(pokemon:game_pokemon,winner:game_pokemon):
	Dialogic.VAR.Battle.Winner = winner.Nick_name
	Dialogic.VAR.Battle.Loser = pokemon.Nick_name
	Dialogic.VAR.Battle.Points = str(pokemon.calculate_experience_points())
	Dialogic.VAR.Battle.Level = str(winner.level)
	
	print_debug(winner.Nick_name, " ", pokemon.Nick_name, " ", str(pokemon.calculate_experience_points()))
	
	Dialogic.start('WinLevelUp')
	
	
func on_won_dialog_finished(dialog):
	if dialog == "Win":
		if BattleManager.EnemyPokemons.size() > 0:
			BattleManager.EnemyPokemons.remove_at(0)
		check_move_learned()

func battle_pokemon_defeated(pokemon):
	if AllyPokemon.all_fainted() == true:
		Lost_battle(pokemon)
	else:
		Lost_match(pokemon)

func Lost_battle(pokemon):
	Dialogic.VAR.Battle.Loser = pokemon.Nick_name

	Dialogic.start('LostBattle')
	

func on_lost_battle_finished(dialog):
	if dialog == "Defeat":
		Utils.get_scene_manager().transistion_exit_battle_loast()
		AllyPokemon.all_heal()
	
func Lost_match(pokemon):
	Dialogic.VAR.Battle.Loser = pokemon.Nick_name

	Dialogic.start('LostMatch')
	

func on_lost_match_finished(dialog):
	pass
	
func _run():
	Dialogic.start('Run')
	

func _run_finished(dialog):
	if dialog == "Ran":
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
	
	Dialogic.VAR.Battle.Caught = pokemon.Nick_name
	Dialogic.start('Caught')
	

func _pokemon_caught_finished(dialog):
	if dialog == "Caught":
		Utils.get_scene_manager().transistion_exit_battle_scene()
