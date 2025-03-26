extends Control

@onready var gift_container: MarginContainer = $GiftContainer
@onready var selection_panel: Panel = $SelectionPanel
@onready var gift_manager: Node = $GiftManager
@onready var gift_picker: Node = $GiftPicker
@onready var message: Panel = $Message
@onready var celebration: Control = $Celebration
@onready var create: Button = $GiftContainer/VBoxContainer/HBoxContainer/Create
@onready var load: Button = $GiftContainer/VBoxContainer/HBoxContainer/Load

enum states {
	NORMAL,
	SELECTION,
	PICKING,
	MESSAGING,
	CELEBRATION,
}

var current_state:states = states.NORMAL:
	set(value):
		current_state = value
		update()

var selected_pokemon_num:int = -1
var selected_pokemon:game_pokemon

func _ready() -> void:
	update()
	
func _on_create_pressed() -> void:
	if current_state == states.NORMAL:
		if AllyPokemon.get_Party_pokemon_size() > 1:
			current_state = states.SELECTION
			AudioManager.input()
		else:
			AudioManager.cancel()
			print("you cannot gift your only pokemon")

func update():
	if current_state == states.NORMAL:
		selection_panel.visible = false
		gift_container.visible = true
		gift_container.grab_focus()
		message.visible = false
		celebration.visible = false
		gift_picker.visible = false
	elif current_state == states.SELECTION:
		selection_panel.visible = true
		selection_panel.start()
		message.visible = false
		celebration.visible = false
	elif current_state == states.MESSAGING:
		selection_panel.visible = false
		message.visible = true
		celebration.visible = false
		gift_picker.visible = false
	elif current_state == states.CELEBRATION:
		selection_panel.visible = false
		message.visible = false
		celebration.visible = true
		gift_picker.visible = false
	elif current_state == states.PICKING:
		selection_panel.visible = false
		message.visible = false
		celebration.visible = false
		gift_picker.visible = true
	

func _on_no_pressed() -> void:
	current_state = states.NORMAL


func _on_selection_panel_yes(num: int, poke: game_pokemon) -> void:
	selected_pokemon_num = num
	selected_pokemon = poke
	current_state = states.MESSAGING
	print(poke.Nick_name)

func send_gift_request(num: int, poke: game_pokemon,msg:String):
	current_state = states.NORMAL
	gift_manager.start_making_gift(num,poke,Utils.player_uid,msg)

func _on_load_pressed() -> void:
	if current_state == states.NORMAL:
		current_state = states.PICKING
		gift_picker.import_gift()
		AudioManager.select()

func _return_to_normal():
	current_state = states.NORMAL
	
func _on_gift_picker_file_found(path: String) -> void:
	current_state = states.NORMAL
	print("should reach here if possible")
	var sucess = gift_manager.load_wonder_gift(path,Utils.player_uid)
	if not sucess == null:
		celebration.celebrate(sucess)

func _on_message_cancelled() -> void:
	selected_pokemon_num = -1
	selected_pokemon = null
	current_state = states.NORMAL

func _on_message_message_submitted(msg: String) -> void:
	send_gift_request(selected_pokemon_num,selected_pokemon,msg)
	_on_message_cancelled()


func _on_gift_picker_cancelled_file_pick() -> void:
	current_state = states.NORMAL


func _on_back_pressed() -> void:
	if current_state == states.NORMAL:
		get_tree().change_scene_to_file("res://src/Main/main_menu.tscn")

func release_all_focus():
	create.release_focus()
	load.release_focus()
	
func _on_celebration_done() -> void:
	await get_tree().create_timer(0.1).timeout
	release_all_focus()
	current_state = states.NORMAL


func _on_celebration_starting() -> void:
	release_all_focus()

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
