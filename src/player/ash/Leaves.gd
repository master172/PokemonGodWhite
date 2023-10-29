extends Node2D

@onready var leafs = $Leafs
@onready var leafs_2 = $Leafs2
@onready var leafs_3 = $Leafs3

func emit(value:bool):
	print_debug(value)
	leafs.set_emitting(value)
	leafs_2.set_emitting(value)
	leafs_3.set_emitting(value)
