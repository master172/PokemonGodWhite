extends Node2D

var battle_scene = preload("res://Core/Battle/battle_scene.tscn")
const evolution_scene = preload("res://Core/Evolutions/evolution_screen.tscn")
const evolution_environment = preload("res://src/Environment/world_environment.tscn")

var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene
@onready var menu = $Menu/Menu
@onready var battle_layer = $BattleLayer
@onready var mart_view = $Mart_View

@export var evolution_dialog:DialogueLine = DialogueLine.new()

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
	EXIT_BATTLE_SCENE,
	BAG_SCENE,
	EXIT_BAG_SCENE,
	EVOLUTION,
	EXIT_EVOLUTION
}
var transition_type = Transition_Type.NEW_SCENE

var save_file_path = "user://save/Scene/"
var save_file_name = "Scene.tres"

var summary_pokemon:int 

var pocket_monster:Array

var WorldEnv:WorldEnvironment = null

signal data_set_finished
signal evolution_finished
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
	first_time_start = Scene_Saver.first_time_start
	if Scene_Saver.scene != "":
		var scene = load(Scene_Saver.scene)
		current_scene.get_child(0).queue_free()
		await get_tree().create_timer(0.01).timeout
		current_scene.add_scene(scene)
		Utils.get_player().load_process()
		Utils.set_player()
		emit_signal("data_set_finished")
		

func first_time_load():
	if first_time_start == true:
		Utils.get_player().first_start()
		first_time_start = false
		Scene_Saver.change_start(first_time_start)
		Scene_Saver.change_scene("res://src/World/Area0.tscn")
	

func get_current_scene():
	return current_scene.get_child(0)

func check_evolution():
	if EvolutionManager.pokemon_to_evolve == []:
		return
	if EvolutionManager.evolving_pokemon == []:
		return
	if EvolutionManager.pokemon_to_evolve.size() != EvolutionManager.evolving_pokemon.size():
		return
	
	ask_evolution()
	
func transition_to_evolution():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EVOLUTION

func transistion_exit_evolution():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_EVOLUTION
	Utils.get_player().set_camera_zoom(4)
	
func transistion_exit_bag_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_BAG_SCENE
	
func transition_to_bag_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BAG_SCENE

func transistion_to_battle_scene(pokemon):
	Utils.get_player().set_physics_process(false)
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BATTLE_SCENE
	pocket_monster = pokemon
	
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
			Inventory.save_overworld_items()
			
			current_scene.get_child(0).queue_free()
			current_scene.add_scene(load(next_scene))
			
			var player = Utils.get_player()
			Utils.set_player()
			player.set_spawn(player_location,player_direction)
			player.set_poke_pos_dir(player.global_position,player.get_current_facing_direction())
			Utils.set_player(false)
			emit_signal("data_set_finished")
		Transition_Type.MENU_ONLY:
			menu.unload_party_screen()
		Transition_Type.PARTY_SCREEN:
			menu.load_party_screen()
		Transition_Type.SUMMARY_SCENE:
			menu.load_summary_screen(summary_pokemon)
		Transition_Type.EXIT_SUMMARY_SCENE:
			menu.unload_summary_screen()
		Transition_Type.BATTLE_SCENE:
			load_battle_scene(pocket_monster)
			pocket_monster =[]
		Transition_Type.EXIT_BATTLE_SCENE:
			unload_battle_scene()
		Transition_Type.BAG_SCENE:
			menu.load_bag_scene()
		Transition_Type.EXIT_BAG_SCENE:
			menu.unload_bag_scene()
		Transition_Type.EVOLUTION:
			load_evolution()
		Transition_Type.EXIT_EVOLUTION:
			re_check_evolution()
	transition_player.play("FadeToNormal")

func check_moves():
	emit_signal("evolution_finished")
	await EvolutionManager.evolution_done
	continue_check_evolution()
	
func re_check_evolution():
	check_moves()

func continue_check_evolution():
	if WorldEnv != null:
		WorldEnv.queue_free()
		WorldEnv = null
		
	if EvolutionManager.pokemon_to_evolve.size() > 0:
		ask_evolution()
	else:
		unlaod_evolution()

func unlaod_evolution():
	Utils.get_player().set_physics_process(true)
	
	
func ask_evolution():
	Utils.get_player().set_physics_process(false)
	evolution_dialog.add_symbols_to_replace({"P1":EvolutionManager.pokemon_to_evolve[0].Nick_name})
	DialogLayer.get_child(0).function_manager.connect("evolve",transition_to_evolution)
	DialogLayer.get_child(0).function_manager.connect("Cancel",cancel_evolution)
	DialogLayer.get_child(0)._start(evolution_dialog)

func cancel_evolution():
	EvolutionManager.remove_evolution_zero()

func load_evolution():
	
	
	var EvolutionScreen = evolution_scene.instantiate()
	EvolutionScreen.set_pokemons(EvolutionManager.pokemon_to_evolve[0],EvolutionManager.evolving_pokemon[0])
	Utils.get_player().add_child(EvolutionScreen)
	Utils.get_player().set_camera_zoom(1)
	
	EvolutionManager.evolve()
	
func load_battle_scene(pokemon):
	
	battle_layer.add_child(battle_scene.instantiate())
	battle_layer.get_child(0).set_enemy(pokemon)
	BattleManager.in_battle = true
	
func unload_battle_scene():
	for i in battle_layer.get_children():
		i.queue_free()
	BattleManager.finish_battle()
	Utils.get_player().set_physics_process(true)
	Utils.get_player().finish_battle()
	AllyPokemon.check_evolution_all()
	
func get_current_scene_name():
	return current_scene.get_child(0).name
