extends Control

@export var showing_pokemon:game_pokemon

@onready var info: ColorRect = $MarginContainer/Main/Panels/Tabs/info
@onready var moves: ColorRect = $MarginContainer/Main/Panels/Tabs/moves
@onready var evolution: ColorRect = $MarginContainer/Main/Panels/Tabs/evolution

@onready var move_manager = $MoveManager
@onready var naming_screen = $NamingScreen

@onready var ball_caught: TextureRect = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/HBoxContainer/BallCaught
@onready var Name: Label = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/HBoxContainer/Name
@onready var gender: TextureRect = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/HBoxContainer/Gender
@onready var level: Label = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/Level
@onready var poke: TextureRect = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/Pokemon
@onready var item: Label = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/ItemContainer/Item
@onready var item_tex: TextureRect = $MarginContainer/Main/Panels/presisting/MainContainer/MarginContainer/DataContainer/ItemContainer/ItemTex
@onready var what: RichTextLabel = $MarginContainer/Main/DataContainer/What

@onready var tabs: TabContainer = $MarginContainer/Main/Panels/Tabs

enum Options {FIRST_SLOT, SECOND_SLOT, THIRD_SLOT, FOURTH_SLOT, FIFTH_SLOT,SIXTH_SLOT}
enum States {Normal,Selection,MoveManagement,Evolution,Inactive,Naming,Items}

var state = States.Normal
var selected_option: int = Options.FIRST_SLOT

var options_selectable:int = 6

@onready var panels :Dictionary = {
	Options.FIRST_SLOT: $MarginContainer/Main/Panels/Tabs/info,
	Options.SECOND_SLOT: $MarginContainer/Main/Panels/Tabs/moves,
	Options.THIRD_SLOT: $MarginContainer/Main/Panels/Tabs/memo,
	Options.FOURTH_SLOT: $MarginContainer/Main/Panels/Tabs/skills,
	Options.FIFTH_SLOT: $MarginContainer/Main/Panels/Tabs/ribbons,
	Options.SIXTH_SLOT: $MarginContainer/Main/Panels/Tabs/evolution
}

var temp_panel:int = 0

func _ready():
	set_active_option()
	move_manager.hide()
	
func unset_active_option():
	pass
	
func set_active_option():
	tabs.current_tab = selected_option
	
	
func _show_info():
	info._display(showing_pokemon)
	_display(showing_pokemon)
	
func set_pokemon(poke_:game_pokemon):
	showing_pokemon = poke_
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
				if evolution.get_max() == 0:
					return
				temp_panel = selected_option
				selected_option = 0
				state = States.Evolution
				options_selectable = evolution.get_max()
				
				evolution.update_display(selected_option,true)
			elif selected_option == 0:
				state = States.Items
				item_tex.self_modulate = Color.GREEN
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
		elif state == States.Items:
			state = States.Normal
			selected_option = 0
			item_tex.self_modulate = Color.WHITE
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
			var next_pokemon = showing_pokemon.get_current_evolution_pokemon(selected_option)
			EvolutionManager.Pokemon_to_evolve = showing_pokemon.duplicate()
			EvolutionManager.Evolving_pokemon = next_pokemon
			state = States.Inactive
			Utils.get_scene_manager().transition_to_evolution()
			showing_pokemon.evolve_with_evolutor(selected_option)
		elif state == States.Items:
			state = States.Normal
			showing_pokemon.remove_item()
			selected_option = 0
			item_tex.self_modulate = Color.WHITE
			display_item()

func display_item():
	if showing_pokemon.held_item == null:
		what.text = "None"
		item_tex.texture = null
	else:
		what.text = showing_pokemon.held_item.Name
		item_tex.texture = showing_pokemon.held_item.sprite
func set_active():
	state = States.Normal
	selected_option = temp_panel
	temp_panel = 0
	options_selectable = 6
	evolution.update_after_evolution(showing_pokemon)
	_display(showing_pokemon)
	info._display(showing_pokemon)
	
func _on_move_manager_quit():
	state = States.Normal
	move_manager.hide()
	move_manager.pokemon = null
	move_manager.active = false
	await get_tree().create_timer(0.1).timeout
	Global.move_management = false
	moves._display(showing_pokemon)

func _display(pokemon:game_pokemon):
	level.text = "Level:- "+str(pokemon.level)
	Name.text = pokemon.Nick_name
	poke.texture = pokemon.Base_Pokemon.Front
	if pokemon.gender == 0:
		gender.texture.region = Rect2(0,0,5,8)
	elif pokemon.gender == 1:
		gender.texture.region = Rect2(5,0,5,8)
	if pokemon.held_item != null:
		what.text = pokemon.held_item.Name
		item_tex.texture = pokemon.held_item.sprite
func _on_naming_screen_naming_done() -> void:
	naming_screen.hide()
	state = States.Normal
	info._display(showing_pokemon)
	if Utils.get_party_screen() != null:
		Utils.get_party_screen().all_update()
