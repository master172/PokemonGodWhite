extends Node

var MovesToLearn:Array[MoveToLearn]
var MoveDeletor = null

var can_learn_moves:bool = false
signal StartLearningMoves(Moves)

@onready var starting_dialog:DialogueLine = preload("res://Resources/Dialogs/move_deletor_Starting.tres")
@onready var ending_dialog:DialogueLine = preload("res://Resources/Dialogs/move_deletor_ending.tres")

func _startMoveLearning():
	emit_signal("StartLearningMoves",MovesToLearn[0])

func Starting_dialog(pokemon,move):
	starting_dialog.add_symbols_to_replace({"Pokemon":pokemon.Nick_name})
	starting_dialog.add_symbols_to_replace({"Move":move.action.name})
	DialogLayer.get_child(0)._start(starting_dialog)
	DialogLayer.get_child(0).connect("finished",finish)

func _finish_move_learning():
	MovesToLearn.remove_at(0)
	
func finish(dial):
	if dial == starting_dialog:
		can_learn_moves = true
		print(can_learn_moves)
