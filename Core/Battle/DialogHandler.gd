extends Node

@export var won_dialog:DialogueLine
@export var won_dialog_level_up:DialogueLine
@export var lost_match:DialogueLine
@export var lost_battle:DialogueLine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_won_dialog(pokemon:game_pokemon,winner:game_pokemon):
	won_dialog.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	won_dialog.add_symbols_to_replace({"Winner":winner.Nick_name})
	won_dialog.add_symbols_to_replace({"points":str(pokemon.calculate_experience_points())})
	DialogLayer.get_child(0)._start(won_dialog)
	DialogLayer.get_child(0).connect("finsished",on_won_dialog_finished)

func add_won_dialog_level_up(pokemon:game_pokemon,winner:game_pokemon):
	won_dialog_level_up.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	won_dialog_level_up.add_symbols_to_replace({"Winner":winner.Nick_name})
	won_dialog_level_up.add_symbols_to_replace({"points":str(pokemon.calculate_experience_points())})
	won_dialog_level_up.add_symbols_to_replace({"level":str(winner.level)})
	DialogLayer.get_child(0)._start(won_dialog_level_up)
	DialogLayer.get_child(0).connect("finsished",on_won_dialog_finished)
	
func on_won_dialog_finished(dialog):
	Utils.get_scene_manager().transistion_exit_battle_scene()

func battle_pokemon_defeated(pokemon):
	if AllyPokemon.all_fainted() == true:
		Lost_battle(pokemon)
	else:
		Lost_match(pokemon)

func Lost_battle(pokemon):
	print(pokemon.Nick_name)
	lost_battle.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	DialogLayer.get_child(0)._start(lost_battle)
	DialogLayer.get_child(0).connect("finsished",on_lost_battle_finished)

func on_lost_battle_finished(dialog):
	Utils.get_scene_manager().transistion_exit_battle_scene()
	
func Lost_match(pokemon):
	print(pokemon.Nick_name)
	lost_match.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	DialogLayer.get_child(0)._start(lost_match)
	DialogLayer.get_child(0).connect("finsished",on_lost_match_finished)

func on_lost_match_finished(dialog):
	pass
