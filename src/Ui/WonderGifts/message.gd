extends Panel

@onready var text_edit: TextEdit = $MarginContainer/VBoxContainer/TextEdit

signal message_submitted(msg:String)
signal cancelled


func _on_text_edit_text_set() -> void:
	emit_signal("message_submitted",text_edit.text)
	text_edit.text = ""

func _on_button_pressed() -> void:
	AudioManager.cancel()
	emit_signal("cancelled")


func _on_set_pressed() -> void:
	AudioManager.select()
	_on_text_edit_text_set()
