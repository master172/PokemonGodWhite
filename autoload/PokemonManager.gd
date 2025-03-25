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
