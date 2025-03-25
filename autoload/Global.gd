extends Node

var Global_Variables :Dictionary= {}

var auto_moves:bool = false
var auto_evolve:bool = false

var move_management :bool = false

var data = {}

var save_file_path = "user://save/Global/"
var save_file_name = "Story.json"

var steps_taken:int = 0:
	set(value):
		if value > 9999:
			value = 0
		steps_taken = value
	get:
		return steps_taken

func _ready():
	verify_save_directory(save_file_path)

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	load_data()
	
func save_var(key: String, value):
	data[key] = value
	save_data()

func load_var(key: String, default = null):
	return data.get(key, default)

func save_data():
	verify_save_directory(save_file_path)
	var file = FileAccess.open(save_file_path+save_file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_data():
	if FileAccess.file_exists(save_file_path+save_file_name):
		var file = FileAccess.open(save_file_path+save_file_name, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()
