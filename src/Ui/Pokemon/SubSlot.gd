extends Node2D
@onready var background = $BackGround

func change_selected(value:bool):
	if value == true:
		background.frame = 1
	else:
		background.frame = 0
