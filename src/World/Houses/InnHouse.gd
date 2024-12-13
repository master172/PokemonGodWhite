extends Node2D

@onready var bea = $Bea

func heal():
	bea.heal()

func get_heal_pos():
	return Vector2(24,48)
	
func get_heal_dir():
	return Vector2(1,0)

