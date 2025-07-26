extends Control

signal closed
@onready var base_container: VBoxContainer = $Main/TopContainer/BaseContainer
@onready var info_container: TabContainer = $Main/TopContainer/InfoContainer

func _set_details(pokemon:Pokemon):
	base_container.present_info(pokemon)
	info_container.present_info(pokemon)

func _input(event):
	if event.is_action_pressed("No"):
		await get_tree().create_timer(0.1).timeout
		if visible == true:
			visible = false
			closed.emit()
