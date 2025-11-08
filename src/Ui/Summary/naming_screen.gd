extends Control

@onready var line_enter = $ColorRect/Panel/VBoxContainer/TextEdit

var active_pokemon : game_pokemon

signal naming_done

func _ready() -> void:
	hide()

func start(pokemon:game_pokemon):
	line_enter.grab_focus()
	active_pokemon = pokemon
	line_enter.text = ""

func _on_text_edit_text_submitted(new_text:String) -> void:
	active_pokemon.Nick_name = new_text
	naming_done.emit()
