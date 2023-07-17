extends Control

enum Options { FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT, SIXTH_SLOT, CANCEL }
var selected_option: int = Options.FIRST_SLOT

@onready var options: Dictionary = {
	Options.FIRST_SLOT: $MainSlot,
	Options.SECOND_SLOT: $Slot2,
	Options.THIRD_SLOT: $Slot3,
	Options.FOURTH_SLOT: $Slot4,
	Options.FIFTH_SLOT: $Slot5,
	Options.SIXTH_SLOT: $Slot6,
	Options.CANCEL: $Cancel,
}


func unset_active_option():
	options[selected_option].change_selected(false)
	
func set_active_option():
	options[selected_option].change_selected(true)

func _ready():
	set_active_option()


func _input(event):
	if event.is_action_pressed("S"):
		unset_active_option()
		selected_option = (selected_option + 1) % 7
		set_active_option()
	elif event.is_action_pressed("W"):
		unset_active_option()
		if selected_option == 0:
			selected_option = Options.CANCEL
		else:
			selected_option -= 1
		set_active_option()
	elif event.is_action_pressed("A"):
		unset_active_option()
		selected_option = 0
		set_active_option()
	elif event.is_action_pressed("D") and selected_option == Options.FIRST_SLOT:
		unset_active_option()
		selected_option = 1
		set_active_option()
	elif event.is_action_pressed("Yes"):
		match selected_option:
			Options.CANCEL:
				Utils.get_scene_manager().transistion_exit_party_screen()
