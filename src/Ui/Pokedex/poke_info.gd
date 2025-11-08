extends Control

signal closed
@onready var base_container: VBoxContainer = $Main/TopContainer/BaseContainer
@onready var info_container: TabContainer = $Main/TopContainer/InfoContainer
@onready var bacground: ColorRect = $Bacground
@onready var moves: VBoxContainer = $Main/TopContainer/InfoContainer/Moves

var prev_pokemon:Pokemon = null

func _set_details(pokemon:Pokemon):
	if prev_pokemon != pokemon:
		reset()
		base_container.present_info(pokemon)
		info_container.present_info(pokemon)
		bacground.set_background(pokemon)
	prev_pokemon = pokemon

func reset():
	info_container.reset_data()
	moves.reset_data()
	
var current_panel:int = 0:
	set(value):
			if current_panel != value:
				current_panel = value
				update_panel(value)
var max_panels:int = 3
	
		
func _input(event):
	if visible == true:
		if event.is_action_pressed("No"):
			await get_tree().create_timer(0.1).timeout
			visible = false
			closed.emit()
		elif event.is_action_pressed("D"):
			current_panel = (current_panel +1) % max_panels
		elif event.is_action_pressed("A"):
			current_panel = (current_panel +max_panels-1) % max_panels

func update_panel(num:int):
	info_container.current_tab = num
