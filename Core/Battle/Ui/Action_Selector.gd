extends Control

@export var DeselectedColor:Color = Color(0.063, 0.443, 0.11, 0.212)
@export var SelectedColor:Color = Color(0.629, 0.028, 0.045)

var options_selectable:int = 4
var selected_option:int = 0

enum Options {FIRST_SLOT,SECOND_SLOT,THIRD_SLOT,FOURTH_SLOT}

@onready var options: Dictionary = {
	Options.FIRST_SLOT: get_node("ColorRect/HBoxContainer/1"),
	Options.SECOND_SLOT: get_node("ColorRect/HBoxContainer/2"),
	Options.THIRD_SLOT: get_node("ColorRect/HBoxContainer/3"),
	Options.FOURTH_SLOT: get_node("ColorRect/HBoxContainer/4"),
}

enum STATES {
	EMPTY,
	RADIAL
}

var state = STATES.EMPTY

signal action_chosen(act:int)
signal cancel
signal displayed

var pokemon:game_pokemon

func _ready():
	pokemon = get_parent().get_parent().pokemon
	_set_radial()
	set_active_option()
	
func unset_active_option():
	options[selected_option].self_modulate = DeselectedColor
	
func set_active_option():
	options[selected_option].self_modulate = SelectedColor

func _input(event):
	if state == STATES.RADIAL:
		_set_radial()
		if event.is_action_pressed("A"):
			AudioManager.input()
			unset_active_option()
			selected_option  = (selected_option +options_selectable - 1) % options_selectable
			set_active_option()
			
		elif event.is_action_pressed("D"):
			AudioManager.input()
			unset_active_option()
			selected_option  = (selected_option + 1) % options_selectable
			set_active_option()
			
		elif event.is_action_pressed("Yes"):
			AudioManager.select()
			emit_signal("action_chosen",selected_option)
			state = STATES.EMPTY
			_set_radial()
			
		elif event.is_action_pressed("No"):
			AudioManager.cancel()
			state = STATES.EMPTY
			_set_radial()
			emit_signal("cancel")
		
func _set_radial():
	if state == STATES.RADIAL:
		visible = true
		emit_signal("displayed")
	else:
		visible = false

func start_radial():
	state = STATES.RADIAL
