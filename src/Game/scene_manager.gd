extends Node2D

var battle_scene = preload("res://Core/Battle/battle_scene.tscn")
var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene
@onready var menu = $Menu/Menu
@onready var battle_layer = $BattleLayer

var first_time_start:bool = true

var Scene_Saver:scene_saver = scene_saver.new()

var player_location
var player_direction

enum Transition_Type {
	NEW_SCENE,
	PARTY_SCREEN,
	SUMMARY_SCENE,
	EXIT_SUMMARY_SCENE,
	MENU_ONLY,
	BATTLE_SCENE,
	EXIT_BATTLE_SCENE
}
var transition_type = Transition_Type.NEW_SCENE

var save_file_path = "user://save/Scene/"
var save_file_name = "Scene.tres"

var summary_pokemon:int 
# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)
	load_data()
	first_time_load()

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_data():
	ResourceSaver.save(Scene_Saver,save_file_path + save_file_name)

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		Scene_Saver = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
		apply_data()
	
	
func apply_data():
	if Scene_Saver.scene != "":
		current_scene.get_child(0).queue_free()
		current_scene.add_child(load(Scene_Saver.scene).instantiate())
	first_time_start = Scene_Saver.first_time_start
	set_player()
	

func first_time_load():
	if first_time_start == true:
		Utils.get_player().first_start()
		first_time_start = false
		Scene_Saver.change_start(first_time_start)
		
func set_player(set_see:bool = true):
	var player = Utils.get_player()
	player.set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	player.check_to_add_overworld_pokemon(set_see)
	player.set_physics_process(true)

func get_current_scene():
	return current_scene.get_child(0)
	

func transistion_to_battle_scene():
	Utils.get_player().set_physics_process(false)
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BATTLE_SCENE

func transistion_exit_battle_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_BATTLE_SCENE
func transistion_to_summary_scene(poke_number:int):
	transition_player.play("FadeToBlack")
	summary_pokemon = poke_number

	transition_type = Transition_Type.SUMMARY_SCENE
	
func transistion_exit_summary_screen():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_SUMMARY_SCENE
	
func transition_to_party_screen():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.PARTY_SCREEN
	
func transistion_exit_party_screen():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.MENU_ONLY
	
func transition_to_scene(new_scene:String, spawn_location:Vector2, spawn_direction:Vector2):
	player_location = spawn_location
	player_direction = spawn_direction
	next_scene = new_scene
	Scene_Saver.change_scene(next_scene)
	transition_type = Transition_Type.NEW_SCENE
	transition_player.play("FadeToBlack")

func finished_fading():
	match transition_type:
		Transition_Type.NEW_SCENE:
			current_scene.get_child(0).queue_free()
			current_scene.add_child(load(next_scene).instantiate())
			
			var player = Utils.get_player()
			player.set_spawn(player_location,player_direction)
			set_player(false)
		
		Transition_Type.MENU_ONLY:
			menu.unload_party_screen()
		Transition_Type.PARTY_SCREEN:
			menu.load_party_screen()
		Transition_Type.SUMMARY_SCENE:
			menu.load_summary_screen(summary_pokemon)
		Transition_Type.EXIT_SUMMARY_SCENE:
			menu.unload_summary_screen()
		Transition_Type.BATTLE_SCENE:
			load_battle_scene()
		Transition_Type.EXIT_BATTLE_SCENE:
			unload_battle_scene()
	transition_player.play("FadeToNormal")

func load_battle_scene():
	
	battle_layer.add_child(battle_scene.instantiate())

func unload_battle_scene():
	for i in battle_layer.get_children():
		i.queue_free()
	Utils.get_player().set_physics_process(true)
