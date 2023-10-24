extends Control

enum Options { FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT, SIXTH_SLOT, CANCEL }
var selected_option: int = Options.FIRST_SLOT

@onready var hold_button = $HoldButton
@onready var button_press_timer = $ButtonPressTimer

@onready var progress_bar = $HoldButton/Background/ProgressBar
@onready var label = $HoldButton/Background/Label


var options_selectable:int = 7

var summary:bool = false

@onready var options: Dictionary = {
	Options.FIRST_SLOT: $MainSlot,
	Options.SECOND_SLOT: $Slot2,
	Options.THIRD_SLOT: $Slot3,
	Options.FOURTH_SLOT: $Slot4,
	Options.FIFTH_SLOT: $Slot5,
	Options.SIXTH_SLOT: $Slot6,
	Options.CANCEL: $Cancel,
}

enum states {
	active,
	blank,
	switching
}

var state = states.active
var waiting = false
var buttonHoldSucessful = false

var switch_a :int
var switch_b :int

func unset_active_option():
	if state != states.switching:
		options[selected_option].change_selected(false)
	elif state == states.switching:
		if selected_option != switch_a:
			options[selected_option].change_selected(false)
	
func set_active_option():
	options[selected_option].change_selected(true)

func _ready():
	options_selectable = AllyPokemon.get_Party_pokemon_size() + 1
	set_active_option()
	hold_button.visible = false
	

func _input(event):
	if event.is_action_pressed("S"):
		if state == states.active and summary == false:
			unset_active_option()
			if selected_option == options_selectable - 2:
				selected_option = 6
			elif selected_option == 6:
				selected_option = 0
			else:
				selected_option = (selected_option + 1) % options_selectable

		set_active_option()
	elif event.is_action_pressed("W"):
		if state == states.active and summary == false:
			unset_active_option()
			if selected_option == 0:
				selected_option = Options.CANCEL
			elif selected_option == Options.CANCEL:
				selected_option -=  (1 + (7 - options_selectable))
			else:
				selected_option -= 1

			set_active_option()
	elif event.is_action_pressed("A"):
		if state == states.active and summary == false:
			unset_active_option()
			selected_option = 0
			set_active_option()
	elif event.is_action_pressed("D") and selected_option == Options.FIRST_SLOT:
		if state == states.active and summary == false:
			if options_selectable >= 3:
				unset_active_option()
				selected_option = 1
				set_active_option()
	elif event.is_action_pressed("Yes"):
		if state == states.active:
			await get_tree().create_timer(0.1).timeout
			if waiting == false:
				if selected_option == 6:
					Utils.get_scene_manager().transistion_exit_party_screen()
				else:
					Utils.get_scene_manager().transistion_to_summary_scene(selected_option)
					summary = true
		elif state == states.switching:
			if selected_option != switch_a:
				switch_b = selected_option
				AllyPokemon.switch_party_pokemon(switch_a,switch_b)
				for i in range(6):
					options[i].update()
				state = states.active
				options[switch_a].change_selected(false)
				var player = Utils.get_player()
				if player != null:
					player.update_following_pokemon()
				
func set_active(s:bool):
	if s == true:
		state = states.active
	else:
		state = states.blank



func _physics_process(delta):
	
	if state != states.switching and summary == false:
		if button_press_timer.is_stopped() == false and waiting == true:
			if button_press_timer.time_left < 0.9:
				hold_button.visible = true
				
		if hold_button.visible == true:
			label.text = "Z"
			progress_bar.value = (1 - button_press_timer.time_left)*100
			
		if Input.is_action_just_pressed("Yes"):
			buttonHoldSucessful = false
			waiting = true
			button_press_timer.start()

		if Input.is_action_just_released("Yes"):
			if buttonHoldSucessful == false:
				waiting = false
				button_press_timer.stop()
				
				print("failed")
			else:
				switch()
			hold_button.visible = false

func switch():
	print("switching")
	state = states.switching
	switch_a = selected_option
	print(switch_a)
func _on_button_press_timer_timeout():
	print("sucessfull")
	buttonHoldSucessful = true
