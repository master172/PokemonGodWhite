extends Node2D

@onready var cave_modulate = $CaveModulate

func _ready():
	Utils.Tilemap = get_node("%mainTilemap")

func get_modulater():
	return cave_modulate
