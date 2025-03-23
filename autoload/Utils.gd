extends Node

var Tilemaps : Array[GameTilemap] = []

var DialogBar = null
var Player = null

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
var kyle_defeated:bool = false
var Lisa_defeated:bool = false
var Law_defeated:bool = false
var Jenney_defeated:bool = false
var Jodi_defeated:bool = false
var FN1_defeated:bool = false
var FN2_defeated:bool = false
var Carter_defeated:bool = false
var Abilene_defeated:bool = false
var Adelle_defeated:bool = false

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
	save_self_data()
	
	if sign == true:
		emit_signal("saving_done")

func update_self_data():
	storyData.player_uid = player_uid
	storyData.aiden_defeated = aiden_defeated
	storyData.Bea_met = Bea_met
	storyData.William_met = William_met
	storyData.kyle_defeated = kyle_defeated
	storyData.Lisa_defeated = Lisa_defeated
	storyData.Law_defeated = Law_defeated
	storyData.Jenney_defeated = Jenney_defeated
	storyData.Jodi_defeated = Jodi_defeated
	storyData.FN1_defeated = FN1_defeated
	storyData.FN2_defeated = FN2_defeated
	storyData.Carter_defeated = Carter_defeated
	storyData.Abilene_defeated = Abilene_defeated
	storyData.Adelle_defeated = Adelle_defeated
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
	kyle_defeated = storyData.kyle_defeated
	Lisa_defeated = storyData.Lisa_defeated
	Law_defeated = storyData.Law_defeated
	Jenney_defeated = storyData.Jenney_defeated
	Jodi_defeated = storyData.Jodi_defeated
	FN1_defeated = storyData.FN1_defeated
	FN2_defeated = storyData.FN2_defeated
	Carter_defeated = storyData.Carter_defeated
	Abilene_defeated = storyData.Abilene_defeated
	Adelle_defeated = storyData.Adelle_defeated
	
func remove_save_files():
	
	##deleting the player save files
	if DirAccess.dir_exists_absolute("user://save/Player/"):
		var dir = DirAccess.open("user://save/Player/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
	
	##deleting scene save files
	if DirAccess.dir_exists_absolute("user://save/Scene/"):
		var dir = DirAccess.open("user://save/Scene/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
	
	
	##Deleting the pokemon save files
	AllyPokemon.remove_data()
	
	##Deleting the inventory save files
	
	Inventory.remove_data()
	
	##Deleting story data
	remove_self_data()

func remove_self_data():
	if DirAccess.dir_exists_absolute("user://save/Utils/"):
		var dir = DirAccess.open("user://save/Utils/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
	
	player_uid = ""
	Money = 100
	Badge_count = 0
	aiden_defeated = false
	Bea_met = false
	William_met = false
	kyle_defeated = false
	Lisa_defeated = false
	Law_defeated = false
	Jenney_defeated = false
	Jodi_defeated = false
	FN1_defeated = false
	FN2_defeated = false
	Carter_defeated = false
	Abilene_defeated = false
	Adelle_defeated = false

func create_uid():
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var uid = ""
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(16):
		uid += chars[rng.randi_range(0, chars.length() - 1)]
	
	player_uid = uid
