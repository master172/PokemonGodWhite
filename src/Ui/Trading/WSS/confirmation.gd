extends Control

enum states {
	ACTIVE,
	INACTIVE
}

var current_state:int = states.INACTIVE

@onready var cancel: Panel = $Panel/VBoxContainer/HBoxContainer/Cancel
@onready var confirm: Panel = $Panel/VBoxContainer/HBoxContainer/Confirm

var selected_color:Color=Color(0.0, 0.848, 0.0, 1.0)
var deselcted_color:Color=Color(1.0, 1.0, 1.0, 1.0)

var current_selected:int = 0
var max_selected:int = 2

@onready var options:Array[Panel] = [confirm,cancel]

signal confirm_trade
signal cancel_trade

func _ready() -> void:
	visible = false

func set_room_button_active():
	options[current_selected].self_modulate = selected_color

func set_room_button_inactive():
	options[current_selected].self_modulate = deselcted_color

func activate():
	visible = true
	set_room_button_active()
	current_state = states.ACTIVE

func _input(event: InputEvent) -> void:
	if current_state == states.ACTIVE:
		if event.is_action_pressed("A"):
			AudioManager.input()
			set_room_button_inactive()
			current_selected = (current_selected + max_selected -1) % max_selected
			set_room_button_active()
		elif event.is_action_pressed("D"):
			AudioManager.input()
			set_room_button_inactive()
			current_selected = (current_selected+1)%max_selected
			set_room_button_active()
		elif event.is_action_pressed("Yes"):
			if current_selected == 0:
				AudioManager.select()
				confirm_trade.emit()
			else:
				AudioManager.cancel()
				cancel_trade.emit()
			deactivate()
		elif event.is_action_pressed("No"):
			AudioManager.cancel()
			cancel_trade.emit()
			deactivate()

func deactivate():
	current_state = states.INACTIVE
	visible = false
