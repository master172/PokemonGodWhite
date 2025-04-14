extends Node

var Tilemaps : Array[GameTilemap] = []

var DialogBar = null
var Player = null
var Menu :Control= null

var DialogProcessing:bool = false

var current_picking_up = null

var player_set:bool = false
var can_encounter:bool = true
var developer_mode:bool = true

signal saving_done
#story variables
var player_uid:String = ""
var Money:int = 100
var Badge_count:int = 0
var aiden_defeated:bool = false
var Bea_met:bool = false
var William_met:bool = false

var storyData :story_saver = story_saver.new()
var save_file_path = "user://save/Utils/"
var save_file_name = "Story.tres"


func player_dialog_end(sign):
	if sign == "DialogicDone":
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(0.1).timeout
		get_player().set_physics_process_custom(true)
		
func _ready():
	Dialogic.connect("signal_event",player_dialog_end)

func handle_load():
	save_file_path =  "user://save/"+str(Global.current_load_path) + "/Utils/"
	verify_save_directory(save_file_path)
	load_data()
	
func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_self_data():
	update_self_data()
	ResourceSaver.save(storyData,save_file_path + save_file_name)
	
func get_player():
	if get_tree().get_current_scene().name == "SceneManager":
		return get_node("/root/SceneManager/Current_scene").get_children().back().get_node("player")
	else:
		var to_return = get_tree().get_nodes_in_group("Player")
		if to_return.size() >= 1:
			return to_return[0]
	return null

func get_party_screen():
	var party_screen = get_node("/root/SceneManager/Menu/PartyScreen")
	if party_screen != null:
		return party_screen
	return null

func get_scene_manager():
	if get_tree().get_current_scene().name == "SceneManager":
		return get_node("/root/SceneManager")
	return null

func set_player(set_see:bool = true):
	var player = get_player()
	if player != null:
		player.check_to_add_overworld_pokemon(set_see)
	else:
		pass

func save_data(sign:bool = true):
	get_player().save_data()
	get_scene_manager().save_data()
	AllyPokemon.save_data()
	Inventory.save_data()
	Global.save_config_info()
	save_self_data()
	
	if sign == true:
		emit_signal("saving_done")

func update_self_data():
	storyData.player_uid = player_uid
	storyData.aiden_defeated = aiden_defeated
	storyData.Bea_met = Bea_met
	storyData.William_met = William_met
	storyData.Badge_count = Badge_count
	storyData.Money = Money
	
func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		storyData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		apply_self_data()
		
func apply_self_data():
	player_uid = storyData.player_uid
	Money = storyData.Money
	Badge_count = storyData.Badge_count
	aiden_defeated = storyData.aiden_defeated
	Bea_met = storyData.Bea_met
	William_met = storyData.William_met
	
func remove_save_files(slot:int):
	
	##deleting the player save files
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/Player/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/Player/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://save/"+str(slot) + "/Player/")
	##deleting scene save files
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/Scene/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/Scene/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://save/"+str(slot) + "/Scene/")
		
	##deleting Trainer save files
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/Trainers/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/Trainers/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://save/"+str(slot) + "/Trainers/")
	##Deleting Story files
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/Global/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/Global/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://save/"+str(slot) + "/Global/")
	##Deleting the pokemon save files
	AllyPokemon.remove_data(slot)
	
	##Deleting the inventory save files
	
	Inventory.remove_data(slot)
	
	##Deleting story data
	remove_self_data(slot)
	
	
	
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/")
		var err = dir.remove("user://save/"+str(slot) + "/")
		if err != OK:
			push_error("failed to delete save slot " + str(slot))
	
	shift_save_slots_down(slot)
	Global.current_load_path -= 1
	
func remove_self_data(slot:int):
	if DirAccess.dir_exists_absolute("user://save/"+str(slot) + "/Utils/"):
		var dir = DirAccess.open("user://save/"+str(slot) + "/Utils/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://save/"+str(slot) + "/Utils/")
	
	unload_data()

func unload_data():
	player_uid = ""
	Money = 100
	Badge_count = 0
	aiden_defeated = false
	Bea_met = false
	William_met = false

func get_numeric_folder_names(path: String) -> Array[int]:
	var dir = DirAccess.open(path)
	if dir == null:
		print("Directory not found:", path)
		return []

	var folder_names: Array[int] = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			if file_name.is_valid_int():
				folder_names.append(file_name.to_int())
		file_name = dir.get_next()
	dir.list_dir_end()

	return folder_names
	
func shift_save_slots_down(start_index: int, save_dir: String = "user://save") -> void:
	var folder_names := get_numeric_folder_names(save_dir)
	
	if folder_names.is_empty():
		return
	
	folder_names.sort()
	var max_index = folder_names[-1]
	# Rename folders from high to low to avoid overwriting
	for slot_index in folder_names: # Go from last to first
		if slot_index > start_index:
			var old_path = save_dir + "/%d" % slot_index
			var new_path = save_dir + "/%d" % (slot_index - 1)

			var err = DirAccess.rename_absolute(old_path, new_path)
			if err != OK:
				print("Failed to rename", old_path, "to", new_path, "Error:", err)
			
func create_uid():
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var uid = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(16):
		uid += chars[rng.randi_range(0, chars.length() - 1)]
	
	player_uid = uid

func autosave():
	if get_scene_manager() != null:
		get_scene_manager().shoot_screen()
		save_data(false)
