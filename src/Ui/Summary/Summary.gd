extends Control

@export var showing_pokemon:game_pokemon

@onready var info = $info

enum Options {FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT}
enum States {Normal,Selection}

var State = States.Normal
var selected_option: int = Options.FIRST_SLOT

var options_selectable:int = 5

@onready var options: Dictionary = {
	Options.FIRST_SLOT: $Info,
	Options.SECOND_SLOT: $Moves,
	Options.THIRD_SLOT: $Memo,
	Options.FOURTH_SLOT: $Skills,
	Options.FIFTH_SLOT: $Ribbons,
}
@onready var panels :Dictionary = {
	Options.FIRST_SLOT: $info,
	Options.SECOND_SLOT: $moves,
	Options.THIRD_SLOT: $memo,
	Options.FOURTH_SLOT: $skills,
	Options.FIFTH_SLOT: $ribbons,
}

func _ready():
	set_active_option()
	
func unset_active_option():
	options[selected_option].frame = 0
	panels[selected_option].visible = false
	
func set_active_option():
	options[selected_option].frame = 1
	panels[selected_option].visible = true
	
func _show_info():
	info._display(showing_pokemon)

func set_pokemon(poke:game_pokemon):
	showing_pokemon = poke
	_show_info()

func _unhandled_input(event):
	if event.is_action_pressed("A"):
		unset_active_option()
		selected_option  = (selected_option +options_selectable - 1) % options_selectable
		set_active_option()
	elif event.is_action_pressed("D"):
		if options_selectable >= 3:
			unset_active_option()
			selected_option  = (selected_option + 1) % options_selectable
			set_active_option()
	elif event.is_action_pressed("Yes"):
		pass
