extends Node

var movesLearned:Array[MoveToLearn]
var MovesToLearn:Array[MoveToLearn]
var MoveDeletor = null

var can_learn_moves:bool = false
signal StartLearningMoves(Moves)
signal CancelMoveLearning(Moves)

signal finishLearningMoves
signal allfinished

@onready var starting_dialog:DialogueLine = preload("res://Resources/Dialogs/move_deletor_Starting.tres")
@onready var ending_dialog:DialogueLine = preload("res://Resources/Dialogs/move_deletor_ending.tres")

enum Signs {
	NEW_MOON,
	WAXING_CRESCENT,
	FIRST_QUARTER_MOON,
	WAXING_GIBBOUS,
	FULL_MOON,
	WANING_GIBBOUS,
	LAST_QUARTER_MOON,
	WANING_CRESCENT,
}

func _start_move_learning():
	if MovesToLearn.size() > 0:
		Starting_dialog(MovesToLearn[0].pokemon,MovesToLearn[0].move)

func _startMoveLearning():
	emit_signal("StartLearningMoves",MovesToLearn[0])

func finsih_learining():
	_finish_move_learning()
	recursive_move_check()

func cancelMoveLearning():
	MovesToLearn[0].move.skipped = true

func Starting_dialog(pokemon,move):
	await get_tree().create_timer(0.1).timeout
	Utils.get_player().set_physics_process(false)
	starting_dialog.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	starting_dialog.add_symbols_to_replace({"Move":move.action.name})
	DialogLayer.get_child(0)._start(starting_dialog)
	DialogLayer.get_child(0).connect("finished",finish)

func finishing_dialog(pokemon,prev_move,new_move):
	can_learn_moves = false
	ending_dialog.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	ending_dialog.add_symbols_to_replace({"OldMove":prev_move.base_action.name})
	ending_dialog.add_symbols_to_replace({"NewMove":new_move.base_action.name})
	DialogLayer.get_child(0)._start(ending_dialog)
	DialogLayer.get_child(0).connect("finished",end_finish)

func _finish_move_learning():
	MovesToLearn.remove_at(0)

func end_finish(dial):
	if dial == ending_dialog:

		_finish_move_learning()
		recursive_move_check()

func recursive_move_check():
	emit_signal("finishLearningMoves")
	if MovesToLearn == []:
		Utils.get_player().set_physics_process_custom(true)
		emit_signal("allfinished")

	else:
		_start_move_learning()

func finish(dial):
	if dial == starting_dialog:
		can_learn_moves = true
		print(can_learn_moves)

func get_current_moon_phase():
	var time = Time.get_datetime_dict_from_system()
	var day = time["weekday"]
	var month = time["month"]
	var year = time["year"]
	var result = moon_phase(month, day, year)
	return result

func moon_phase(month:int, day:int, year:int) -> Signs:
	var ages = [18, 0, 11, 22, 3, 14, 25, 6, 17, 28, 9, 20, 1, 12, 23, 4, 15, 26, 7]
	var offsets = [-1, 1, 0, 1, 2, 3, 4, 5, 7, 7, 9, 9]
	var description = [
		Signs.NEW_MOON,
		Signs.WAXING_CRESCENT,
		Signs.FIRST_QUARTER_MOON,
		Signs.WAXING_GIBBOUS,
		Signs.FULL_MOON,
		Signs.WANING_GIBBOUS,
		Signs.LAST_QUARTER_MOON,
		Signs.WANING_CRESCENT
	]

	# Correct 19-year cycle alignment
	var year_index = int((year - 1900) % 19)
	
	# Core calculation
	var days_into_phase = int((ages[year_index] + day + offsets[month - 1]) % 30)
	
	# Normalize to phase index
	var index = int(floor((days_into_phase / 30.0) * 8))
	if index > 7:
		index = 7
	
	return description[index]
