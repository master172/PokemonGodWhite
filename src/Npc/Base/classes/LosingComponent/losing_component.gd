extends Node2D
class_name LosingComponent

signal battle_over
signal check_battle

func _ready():
	if get_parent() != null:
		get_parent().set_losing_component(self)
	

func _connect():
	if Utils.get_scene_manager() != null:
		Utils.get_scene_manager().connect("trainer_battle_finished",my_battle_finished)

func my_battle_finished():
	emit_signal("check_battle")

func get_losing(losing:bool):
	if losing == true:
		emit_signal("battle_over")
