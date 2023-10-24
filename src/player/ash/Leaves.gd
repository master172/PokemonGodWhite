extends Node2D

@onready var leafs = $Leafs
@onready var leafs_2 = $Leafs2
@onready var leafs_3 = $Leafs3

func emit():
	leafs.emitting = true
	leafs_2.emitting = true
	leafs_3.emitting = true
