extends Node

var Global_Variables :Dictionary= {}

var auto_moves:bool = false
var auto_evolve:bool = false

var move_management :bool = false

var save_data: SaveData

var save_file_path = "user://save/Global/"
var save_file_name = "Story.tres"

var current_load_path:int = 0
var num_active_path:int = 0
var max_active_path:int = 0

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
	load_config_info()

func start_load():
	save_file_path = "user://save/"+str(current_load_path)+"/Global/"
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

func save_config_info():
	save_config_file()

func load_config_info():
	load_config_file()
	
func save_config_file():
	var config = ConfigFile.new()
	var save_time = Time.get_datetime_string_from_system()
	config.set_value("save_data", "last_save_time", save_time)
	config.set_value("save_data","current_load_path",str(current_load_path))
	var error = config.save("user://save/save_config.cfg")
	if error != OK:
		print("failed to save config file")
		return

func load_config_file():
	var config = ConfigFile.new()
	var error = config.load("user://save/save_config.cfg")

	if error == OK:
		var last_time = config.get_value("save_data", "last_save_time", "Never saved")
		current_load_path = int(config.get_value("save_data","current_load_path",0))
		print("Last save time was:", last_time)
		return last_time
	else:
		print("No save config found.")
		return "Never saved"
