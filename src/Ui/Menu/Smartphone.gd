extends Control

var max_selectable:int = 0
var current_selected:int = 0

@onready var grid_container = $Screen/GridContainer

const Party_Screen = preload("res://src/Ui/Pokemon/party_screen.tscn")
const Summary_scene = preload("res://src/Ui/Summary/Summary.tscn")
const Bag_Scene = preload("res://src/Ui/Bag/bag.tscn")
const Switch_Scene = preload("res://src/Ui/Pc/poke_storage.tscn")
const Trainer_card = preload("res://src/Ui/TrainerCard/trainer_card.tscn")
const POKEDEX = preload("res://src/Ui/Pokedex/pokedex.tscn")

var Summary_Scene

signal saving_done

var lock:bool = false

enum current_state {
	Empty,
	Normal,
	Pokemons,
	Summary,
	Bag,
	Save,
	Switching,
	Card,
	Pokedex,
}

var CurrentState = current_state.Empty
# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Menu = self
	Utils.connect("saving_done",show)
	DialogLayer.get_child(0).function_manager.connect("Save",save)
	self.visible = false


@export var Save_dialog:DialogueLine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	match CurrentState:
		current_state.Empty:
			if event.is_action_pressed("Menu") and BattleManager.in_battle == false:
				if lock == false:
					AudioManager.select()
					var player = Utils.get_player()
					if !player.is_moving:
						player.set_physics_process(false)
						self.visible = true
						CurrentState = current_state.Normal
					
		current_state.Normal:
			if event.is_action_pressed("Menu") or event.is_action_pressed("No"):
				AudioManager.cancel()
				quit()

			else:
				max_selectable = 0
				if CurrentState == current_state.Normal:
					for i in grid_container.get_children():
						if i.visible == true:
							max_selectable += 1
					grid_container.get_child(current_selected).change_selected(true)
					
				if event.is_action_pressed("A"):
					AudioManager.input()
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected +max_selectable - 1) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
					
				elif event.is_action_pressed("D"):
					AudioManager.input()
					grid_container.get_child(current_selected).change_selected(false)
					current_selected = (current_selected + 1) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
					
				elif event.is_action_pressed("W"):
					AudioManager.input()
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected + 4) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
				
				elif event.is_action_pressed("S"):
					AudioManager.input()
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected +max_selectable - 4) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
				
				elif event.is_action_pressed("Yes"):
					AudioManager.select()
					if current_selected == 0:
						Utils.get_scene_manager().transition_to_party_screen()
					elif current_selected == 1:
						Utils.get_scene_manager().transition_to_pokedex_scene()
					elif current_selected == 2:
						Utils.get_scene_manager().transition_to_bag_scene()
					elif current_selected == 4:
						save_dialog()
						CurrentState = current_state.Save
					elif current_selected == 7:
						Utils.Menu = null
						get_tree().change_scene_to_file("res://src/Main/main_menu.tscn")
					elif current_selected == 6:
						load_switching_scene()
					elif current_selected == 3:
						load_trainer_card()

		current_state.Pokemons:
			if event.is_action_pressed("No"):
				AudioManager.cancel()
				Utils.get_scene_manager().transistion_exit_party_screen()
		current_state.Summary:
			if event.is_action_pressed("No"):
				AudioManager.cancel()
				if Global.move_management == false:
					Utils.get_scene_manager().transistion_exit_summary_screen()
		current_state.Card:
			if event.is_action_pressed("No"):
				AudioManager.cancel()
				unload_trainer_card()
			


func handle_closing():
	for i in grid_container.get_children():
		i.change_selected(false)

func load_trainer_card():
	hide()
	CurrentState = current_state.Card
	var scene = Trainer_card.instantiate()
	get_parent().add_child(scene)

func unload_trainer_card():
	show()
	CurrentState = current_state.Normal
	get_parent().get_node("TrainerCard").queue_free()
	
func load_switching_scene():
	hide()
	CurrentState = current_state.Switching
	var scene = Switch_Scene.instantiate()
	scene.connect("Quit",unload_switching_scene)
	get_parent().add_child(scene)

func unload_switching_scene():
	show()
	get_parent().get_node("PokeStorage").queue_free()
	await get_tree().create_timer(0.1).timeout
	CurrentState = current_state.Normal
	
func load_bag_scene():
	hide()
	CurrentState =current_state.Bag
	var scene = Bag_Scene.instantiate()
	get_parent().add_child(scene)

func unload_bag_scene():
	if BattleManager.in_battle == false:
		show()
	get_parent().get_node("Bag").queue_free()
	if BattleManager.in_battle == false:
		CurrentState = current_state.Normal
	else:
		CurrentState = current_state.Empty
		
func load_party_screen():
	visible = false
	CurrentState = current_state.Pokemons
	var scene = Party_Screen.instantiate()
	get_parent().add_child(scene)

func unload_party_screen():
	visible = true
	get_parent().get_node("PartyScreen").queue_free()
	CurrentState = current_state.Normal

func load_summary_screen(summary_id:int):
	visible = false
	CurrentState = current_state.Summary
	Summary_Scene = Summary_scene.instantiate()
	get_parent().get_node("PartyScreen").set_active(false)
	get_parent().add_child(Summary_Scene)
	get_parent().get_node("Summary").set_pokemon(AllyPokemon.get_party_pokemon(summary_id))

func set_summary_active():
	get_parent().get_node("Summary").set_active()
	
func unload_summary_screen():
	visible = false
	get_parent().get_node("PartyScreen").set_active(true)
	get_parent().get_node("PartyScreen").summary = false
	if is_instance_valid(Summary_Scene):
		get_parent().get_node("Summary").queue_free()
	CurrentState = current_state.Pokemons

func save_dialog():
	DialogLayer.get_child(0)._start(Save_dialog)
	DialogLayer.get_child(0).connect("finished",save_dialog_finished)
	
func save():
	Utils.get_scene_manager().shoot_screen()
	Utils.save_data()
	
func load_pokedex():
	visible = false
	CurrentState = current_state.Pokedex
	var scene = POKEDEX.instantiate()
	get_parent().add_child(scene)

func unload_pokedex():
	visible = true
	get_parent().get_node("Pokedex").queue_free()
	CurrentState = current_state.Normal
	
func save_dialog_finished(Dialogline):
	if Dialogline == Save_dialog:
		CurrentState = current_state.Normal
		DialogLayer.get_child(0).disconnect("finished",save_dialog_finished)

func quit():
	
	var player = Utils.get_player()
	self.visible = false
	CurrentState = current_state.Empty
	handle_closing()
	if BattleManager.in_battle == false:
		player.set_physics_process(true)
