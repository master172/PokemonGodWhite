extends Control

@onready var slot_container: VBoxContainer = $MarginContainer/MainContainer/ScrollContainer/SlotContainer
const LOAD_PANEL = preload("res://src/Main/LoadPanel.tscn")

var active:bool = false:
	set(value):
		active = value
		visible = active

func _ready() -> void:
	visible = active
	add_nodes()
	
func add_nodes():
	for i in range(0,count_save_folders()):
		var slot = LOAD_PANEL.instantiate()
		slot_container.add_child(slot)
		slot.slot_index = i

func unset_selected(num:int):
	slot_container.get_child(num).active = false

func set_selected(num:int):
	slot_container.get_child(num).active = true
	
func count_save_folders() -> int:
	var dir = DirAccess.open("user://save")
	if dir == null:
		print("Directory not found.")
		return 0

	var folder_count = 0
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			folder_count += 1
		file_name = dir.get_next()

	dir.list_dir_end()
	return folder_count
