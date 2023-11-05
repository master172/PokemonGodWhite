extends Node

var Tilemap = null
var DialogBar = null
var Player = null

var DialogProcessing:bool = false

var current_picking_up = null

var player_set:bool = false
var can_encounter:bool = true

signal saving_done
#story variables
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
		get_player().set_physics_process(true)
		
func _ready():
	Dialogic.connect("signal_event",player_dialog_end)
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

func save_data():
	get_player().save_data()
	get_scene_manager().save_data()
	AllyPokemon.save_data()
	Inventory.save_data()
	save_self_data()
	emit_signal("saving_done")

func update_self_data():
	storyData.aiden_defeated = aiden_defeated
	storyData.Bea_met = Bea_met
	storyData.William_met = William_met

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		storyData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		apply_self_data()
		
func apply_self_data():
	aiden_defeated = storyData.aiden_defeated
	Bea_met = storyData.Bea_met
	William_met = storyData.William_met
