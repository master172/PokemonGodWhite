extends Control

@onready var gift_container: MarginContainer = $GiftContainer
@onready var selection_panel: Panel = $SelectionPanel
@onready var gift_manager: Node = $GiftManager
@onready var gift_picker: Node = $GiftPicker

enum states {
	NORMAL,
	SELECTION,
	PICKING
}

var current_state:states = states.NORMAL:
	set(value):
		current_state = value
		update()

var selected_pokemon_num:int = 0
var selected_pokemon:game_pokemon



func _ready() -> void:
	update()
	
func _on_create_pressed() -> void:
	if current_state == states.NORMAL:
		if AllyPokemon.get_Party_pokemon_size() > 1:
			current_state = states.SELECTION
			AudioManager.input()
		else:
			print("you cannot gift your only pokemon")

func update():
	if current_state == states.NORMAL:
		selection_panel.visible = false
		gift_container.visible = true
	elif current_state == states.SELECTION:
		selection_panel.visible = true
		selection_panel.start()


func _on_no_pressed() -> void:
	current_state = states.NORMAL


func _on_selection_panel_yes(num: int, poke: game_pokemon) -> void:
	print(poke.Nick_name)
	current_state = states.NORMAL
	var result :String = gift_manager.start_making_gift(num,poke,Utils.player_uid)
	if not result.begins_with("could not create gift"):
		OS.alert("the gift file was created at "+result+ " share this file to your friends","gift created")
	else:
		OS.alert(result,"failed to create gift")
func _on_load_pressed() -> void:
	if current_state == states.NORMAL:
		current_state = states.PICKING
		gift_picker.import_gift()


func _on_gift_picker_file_found(path: String) -> void:
	current_state = states.NORMAL
	gift_manager.load_wonder_gift(path,Utils.player_uid)
