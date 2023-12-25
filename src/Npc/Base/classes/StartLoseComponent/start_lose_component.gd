extends Node2D

func _ready():
	if get_parent() != null:
		get_parent().set_start_lose_component(self)

func start_process():
	pass
