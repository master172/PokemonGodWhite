extends Control

const POKE_ENTRY = preload("res://src/Ui/Pokedex/poke_entry.tscn")
	
const PATH = "res://Core/Pokemon"
const EXTENSION = "tres"

# Called when the node enters the scene tree for the first time.
var dir_path = "res://Core/Pokemon/"
var desired_extension = "tres"

var matched_results :Array[Pokemon] = []

@onready var v_box_container = $HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var scroll_container = $HBoxContainer/VBoxContainer/ScrollContainer
@onready var line_edit: LineEdit = $HBoxContainer/VBoxContainer/LineEdit

var current_selected:int = 0
var max_selected:int = 0

var active:bool = false

signal pokemon_searched
signal selected(poke:Pokemon)

func dir_contents(path,search:String=""):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.get_extension() == EXTENSION:
					var pokemon_name = file_name.get_basename()
					var pokemon = file_name
					if search != "":
						if search.to_lower() in pokemon_name.to_lower():
							print_debug("Found Pokemon: " + pokemon_name)
							matched_results.append(load(PATH+"/"+pokemon))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func _on_line_edit_text_submitted(new_text):
	matched_results.clear()
	print(new_text)
	dir_contents(PATH,new_text)
	display_results()
	pokemon_searched.emit()
	
func display_results():
	if v_box_container.get_child_count() > 0:
		for i in v_box_container.get_children():
			i.queue_free()
	
	for i in matched_results:
		var ENTRY = POKE_ENTRY.instantiate()
		ENTRY.pokemon = i
		v_box_container.add_child(ENTRY)
	
	max_selected = v_box_container.get_child_count() - 1

func _input(event):
	if event is InputEventAction:
		if event.is_action_pressed("S"):
			if active == true:
				set_inactive()
				
				if current_selected >= 4:
					scroll_container.scroll_vertical += 128
				if current_selected < max_selected:
					current_selected = current_selected + 1
				else:
					current_selected = 0
				
				if current_selected == 0:
					scroll_container.scroll_vertical = 0
				
				set_active()
		elif event.is_action_pressed("W"):
			if active == true:
				set_inactive()
				
				scroll_container.scroll_vertical -= 128
				
				if current_selected > 0:
					current_selected = current_selected - 1
				else:
					current_selected = max_selected
				
				if current_selected == max_selected:
					scroll_container.scroll_vertical = v_box_container.get_child_count() * 128
				set_active()
		elif event.is_action_pressed("Yes"):
			if active == true:
				var pokemon = v_box_container.get_child(current_selected).pokemon
				selected.emit(pokemon)

func set_inactive():
	if v_box_container.get_child_count() > 0:
		v_box_container.get_child(current_selected).set_selected(false)
	
func set_active():
	if v_box_container.get_child_count() > 0:
		v_box_container.get_child(current_selected).set_selected(true)
