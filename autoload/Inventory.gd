extends Node

@export var pocket:Pockets = Pockets.new()

var save_file_path = "user://save/Bag/"
var save_file_name = "Items.tres"

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)

func _ready():
	verify_save_directory(save_file_path)
	load_data()

func save_data():
	ResourceSaver.save(pocket,save_file_path + save_file_name)
	
func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		pocket = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)

func remove_data():
	if DirAccess.dir_exists_absolute("user://save/Bag/"):
		var dir = DirAccess.open("user://save/Bag/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		
	pocket = Pockets.new()
	
	if DirAccess.dir_exists_absolute("user://Save/OverWorld/"):
		var dir = DirAccess.open("user://Save/OverWorld/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
