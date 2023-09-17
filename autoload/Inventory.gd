extends Node

@export var pocket:Pockets = Pockets.new()

var save_file_path = "user://save/Bag/"
var save_file_name = "Items.tres"

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	DirAccess.make_dir_recursive_absolute("user://save/OverWorld/")
	load_data()
	
func _ready():
	verify_save_directory(save_file_path)
	
func save_data():
	ResourceSaver.save(pocket,save_file_path + save_file_name)
	save_overworld_items()
	
func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		pocket = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	
	
func save_overworld_items():
	var save_game = FileAccess.open("user://Save/OverWorld/"+Utils.get_scene_manager().get_current_scene_name() +"OverworldItems.json",FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		var node_data = node.call("save")
		
		var json_string = JSON.stringify(node_data)
		
		save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://Save/OverWorld/"+Utils.get_scene_manager().get_current_scene_name() +"OverworldItems.json"):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	var save_game = FileAccess.open("user://Save/OverWorld/"+Utils.get_scene_manager().get_current_scene_name() +"OverworldItems.json",FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var node_data = json.get_data()
		
		var scene_to_load = node_data["scene"]

		var object = get_node(node_data["node"])
		print("set node '%s' in the current scene" % object.name)
			
		for i in node_data.keys():
			object.set(i,node_data[i])
			
		if object.has_method("set_load"):
			object.set_load()
		
