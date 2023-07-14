extends Control

var max_selectable:int = 0
var current_selected:int = 0

@onready var grid_container = $Screen/GridContainer

const Party_Screen = preload("res://src/Ui/Pokemon/party_screen.tscn")

enum current_state {
	Empty,
	Normal,
	Pokemon
}

var CurrentState = current_state.Empty
# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(event):
	match CurrentState:
		current_state.Empty:
			if event.is_action_pressed("Menu"):
				var player = get_parent().get_parent().get_node("Current_scene").get_children().back().get_node("player")
				if !player.is_moving:
					player.set_physics_process(false)
					self.visible = true
					CurrentState = current_state.Normal
		current_state.Normal:
			if event.is_action_pressed("Menu") or event.is_action_pressed("No"):
				var player = get_parent().get_parent().get_node("Current_scene").get_children().back().get_node("player")
				self.visible = false
				CurrentState = current_state.Empty
				handle_closing()
				player.set_physics_process(true)
			else:
				handle_app()
		current_state.Pokemon:
			if event.is_action_pressed("No"):
				get_parent().get_parent().transistion_exit_party_screen()

func handle_app():
	max_selectable = 0
	if CurrentState == current_state.Normal:
		for i in grid_container.get_children():
			if i.visible == true:
				max_selectable += 1
		grid_container.get_child(current_selected).change_selected(true)
		
	if Input.is_action_just_pressed("A"):
		grid_container.get_child(current_selected).change_selected(false)
		current_selected  = (current_selected - 1) % max_selectable
		grid_container.get_child(current_selected).change_selected(true)
		
	elif Input.is_action_just_pressed("D"):
		grid_container.get_child(current_selected).change_selected(false)
		current_selected = (current_selected + 1) % max_selectable
		grid_container.get_child(current_selected).change_selected(true)
		
	elif Input.is_action_just_pressed("W"):
		grid_container.get_child(current_selected).change_selected(false)
		current_selected  = (current_selected + 4) % max_selectable
		grid_container.get_child(current_selected).change_selected(true)
	
	elif Input.is_action_just_pressed("S"):
		grid_container.get_child(current_selected).change_selected(false)
		current_selected  = (current_selected - 4) % max_selectable
		grid_container.get_child(current_selected).change_selected(true)
	
	elif Input.is_action_just_pressed("Yes"):
		if current_selected == 0:
			get_parent().get_parent().transition_to_party_screen()

func handle_closing():
	for i in grid_container.get_children():
		i.change_selected(false)

func load_party_screen():
	visible = false
	CurrentState = current_state.Pokemon
	var scene = Party_Screen.instantiate()
	get_parent().add_child(scene)

func unload_party_screen():
	visible = true
	get_parent().get_node("PartyScreen").queue_free()
	CurrentState = current_state.Normal
