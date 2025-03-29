extends Control

@export var showing_pokemon:game_pokemon

@onready var info = $info
@onready var move_manager = $MoveManager
@onready var evolution = $evolution
@onready var moves = $moves
@onready var naming_screen = $NamingScreen

enum Options {FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT,SIXTH_SLOT}
enum States {Normal,Selection,MoveManagement,Evolution,Inactive,Naming}

var state = States.Normal
var selected_option: int = Options.FIRST_SLOT

var options_selectable:int = 6



@onready var options: Dictionary = {
	Options.FIRST_SLOT: $Info,
	Options.SECOND_SLOT: $Moves,
	Options.THIRD_SLOT: $Memo,
	Options.FOURTH_SLOT: $Skills,
	Options.FIFTH_SLOT: $Ribbons,
	Options.SIXTH_SLOT: $Evolution

}
@onready var panels :Dictionary = {
	Options.FIRST_SLOT: $info,
	Options.SECOND_SLOT: $moves,
	Options.THIRD_SLOT: $memo,
	Options.FOURTH_SLOT: $skills,
	Options.FIFTH_SLOT: $ribbons,
	Options.SIXTH_SLOT: $evolution
}

var temp_panel:int = 0

func _ready():
	set_active_option()
	move_manager.hide()
	
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
		AudioManager.input()
		AudioManager.input()
		if state == States.Normal:
			unset_active_option()
			selected_option  = (selected_option +options_selectable - 1) % options_selectable
			set_active_option()
			if panels[selected_option].has_method("_display"):
				panels[selected_option]._display(showing_pokemon)
	elif event.is_action_pressed("D"):
		AudioManager.input()
		if state == States.Normal:
			if options_selectable >= 3:
				unset_active_option()
				selected_option  = (selected_option + 1) % options_selectable
				set_active_option()
				if panels[selected_option].has_method("_display"):
					panels[selected_option]._display(showing_pokemon)
	elif event.is_action_pressed("S"):
		AudioManager.input()
		if state == States.Normal:
			if selected_option == 5:
				temp_panel = selected_option
				selected_option = 0
				state = States.Evolution
				options_selectable = evolution.get_max()
				
				evolution.update_display(selected_option,true)
			
		elif state == States.Evolution:
			evolution.update_display(selected_option,false)
			selected_option  = (selected_option + 1) % options_selectable
			evolution.update_display(selected_option,true)
			
			if selected_option == 0:
				evolution.scroll_full_up()
			if selected_option > 1:
				evolution.scroll_down()
			
	elif event.is_action_pressed("W"):
		AudioManager.input()
		if state ==States.Evolution:
			if selected_option == 0:
				evolution.update_display(selected_option,false)
				state = States.Normal
				selected_option = temp_panel
				temp_panel = 0
				options_selectable = 6
			else:
				evolution.update_display(selected_option,false)
				selected_option  = (selected_option +options_selectable - 1) % options_selectable
				evolution.update_display(selected_option,true)
				
				if selected_option == 0:
					evolution.scroll_full_up()
				if selected_option > 0:
					evolution.scroll_up()
				
	elif event.is_action_pressed("Yes"):
		AudioManager.select()
		if  state == States.Normal:
			if selected_option == 0:
				state = States.Naming
				naming_screen.show()
				naming_screen.start(showing_pokemon)
			elif selected_option == 1:
				state = States.MoveManagement
				move_manager.show()
				move_manager.pokemon = showing_pokemon
				move_manager.all_update()
				move_manager.active = true
				Global.move_management = true
		elif state == States.Evolution:
			var pokemon = showing_pokemon
			var next_pokemon = showing_pokemon.get_current_evolution_pokemon(selected_option)
			EvolutionManager.Pokemon_to_evolve = showing_pokemon.duplicate()
			EvolutionManager.Evolving_pokemon = next_pokemon
			state = States.Inactive
			Utils.get_scene_manager().transition_to_evolution()
			showing_pokemon.evolve_with_evolutor(selected_option)

func set_active():
	state = States.Normal
	selected_option = temp_panel
	temp_panel = 0
	options_selectable = 6
	evolution.update_after_evolution(showing_pokemon)
	info._display(showing_pokemon)
	
func _on_move_manager_quit():
	state = States.Normal
	move_manager.hide()
	move_manager.pokemon = null
	move_manager.active = false
	await get_tree().create_timer(0.1).timeout
	Global.move_management = false
	moves._display(showing_pokemon)


func _on_naming_screen_naming_done() -> void:
	naming_screen.hide()
	state = States.Normal
	info._display(showing_pokemon)
	if Utils.get_party_screen() != null:
		Utils.get_party_screen().all_update()
