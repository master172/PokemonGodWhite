extends Control

signal closed

func _set_details(pokemon:Pokemon):
	pass

func _input(event):
	if event.is_action_pressed("No"):
		await get_tree().create_timer(0.1).timeout
		if visible == true:
			visible = false
			closed.emit()
