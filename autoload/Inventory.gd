extends Node

@export var pocket:Pockets = Pockets.new()

var save_file_path = "user://save/Bag/"
var save_file_name = "Items.tres"

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	load_data()
	
func _ready():
	verify_save_directory(save_file_path)
	
func save_data():
	ResourceSaver.save(pocket,save_file_path + save_file_name)

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		pocket = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)

