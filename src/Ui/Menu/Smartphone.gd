extends Control

var max_selectable:int = 0
var current_selected:int = 0

@onready var grid_container = $Screen/GridContainer

const Party_Screen = preload("res://src/Ui/Pokemon/party_screen.tscn")
const Summary_scene = preload("res://src/Ui/Summary/Summary.tscn")

var Summary_Scene

enum current_state {
	Empty,
	Normal,
	Pokemons,
	Summary,
	Save
}

var CurrentState = current_state.Empty
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	
@export var Save_dialog:DialogueLine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	match CurrentState:
		current_state.Empty:
			if event.is_action_pressed("Menu") and BattleManager.in_battle == false:
				var player = Utils.get_player()
				if !player.is_moving:
					player.set_physics_process(false)
					self.visible = true
					CurrentState = current_state.Normal
		current_state.Normal:
			if event.is_action_pressed("Menu") or event.is_action_pressed("No"):
				var player = Utils.get_player()
				self.visible = false
				CurrentState = current_state.Empty
				handle_closing()
				player.set_physics_process(true)
			else:
				max_selectable = 0
				if CurrentState == current_state.Normal:
					for i in grid_container.get_children():
						if i.visible == true:
							max_selectable += 1
					grid_container.get_child(current_selected).change_selected(true)
					
				if event.is_action_pressed("A"):
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected - 1) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
					
				elif event.is_action_pressed("D"):
					grid_container.get_child(current_selected).change_selected(false)
					current_selected = (current_selected + 1) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
					
				elif event.is_action_pressed("W"):
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected + 4) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
				
				elif event.is_action_pressed("S"):
					grid_container.get_child(current_selected).change_selected(false)
					current_selected  = (current_selected - 4) % max_selectable
					grid_container.get_child(current_selected).change_selected(true)
				
				elif event.is_action_pressed("Yes"):
					if current_selected == 0:
						Utils.get_scene_manager().transition_to_party_screen()
					elif current_selected == 4 or current_selected == -4:
						save_dialog()
						CurrentState = current_state.Save
						
		current_state.Pokemons:
			if event.is_action_pressed("No"):
				Utils.get_scene_manager().transistion_exit_party_screen()
		current_state.Summary:
			if event.is_action_pressed("No"):
				Utils.get_scene_manager().transistion_exit_summary_screen()


func handle_closing():
	for i in grid_container.get_children():
		i.change_selected(false)

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
	
func unload_summary_screen():
	visible = false
	get_parent().get_node("PartyScreen").set_active(true)
	if is_instance_valid(Summary_Scene):
		get_parent().get_node("Summary").queue_free()
	CurrentState = current_state.Pokemons

func save_dialog():
	DialogLayer.get_child(0)._start(Save_dialog)
	DialogLayer.get_child(0).connect("finsished",save_dialog_finished)
	
func save():
	Utils.save_data()

func save_dialog_finished(Dialogline):
	if Dialogline == Save_dialog:
		CurrentState = current_state.Normal
		DialogLayer.get_child(0).disconnect("finsished",save_dialog_finished)
