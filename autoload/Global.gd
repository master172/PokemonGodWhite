extends Node

var Global_Variables :Dictionary= {}

var auto_moves:bool = false
var auto_evolve:bool = false

var move_management :bool = false

var save_data: SaveData

var save_file_path = "user://save/Global/"
var save_file_name = "Story.tres"

var steps_taken:int = 0:
	set(value):
		if value > 9999:
			value = 0
		steps_taken = value
		emit_signal("steps_updated",value)
	get:
		return steps_taken

signal steps_updated(steps:int)

func _ready():
	verify_save_directory(save_file_path)

func verify_save_directory(path: String):
	DirAccess.make_dir_recursive_absolute(path)
	load_data()  # Load after ensuring directory exists

func save_var(caller: String, key: String, value):
	if not save_data.data.has(caller):
		save_data.data[caller] = {}
	save_data.data[caller][key] = value
	save_data_to_disk()

func load_var(caller: String, key: String, default = null):
	if save_data.data.has(caller):
		return save_data.data[caller].get(key, default)
	return default

func has_var(caller: String, key: String) -> bool:
	return save_data.data.has(caller) and save_data.data[caller].has(key)

func save_data_to_disk():
	var full_path = save_file_path + save_file_name
	var err = ResourceSaver.save(save_data, full_path)
	if err != OK:
		print("Save failed with error code: ", err)

func load_data():
	var full_path = save_file_path + save_file_name
	if ResourceLoader.exists(full_path):
		save_data = ResourceLoader.load(full_path) as SaveData
	else:
		save_data = SaveData.new()
		
