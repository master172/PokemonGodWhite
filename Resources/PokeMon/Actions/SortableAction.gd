extends Node
class_name ScorableAction

@export var score:int = 0
@export var action:GameAction
@export var pos:int = 0

func _init(Score:int = 0,MyAction:GameAction=null,Pos:int = 0) -> void:
	score = score
	action = MyAction
	pos = Pos
