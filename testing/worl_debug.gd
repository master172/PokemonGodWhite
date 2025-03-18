extends Control

func _on_button_toggled(button_pressed):
	Utils.can_encounter = button_pressed


func _on_button_2_toggled(toggled_on:bool) -> void:
	Utils.developer_mode = toggled_on
