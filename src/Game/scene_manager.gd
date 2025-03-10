extends Node2D

var battle_scene = preload("res://Core/Battle/battle_scene.tscn")
const evolution_scene = preload("res://Core/Evolutions/evolution_screen.tscn")
const evolution_environment = preload("res://src/Environment/world_environment.tscn")

const default_healing_place = preload("res://src/World/Houses/InnHouse.tscn")

var current_healing_place = null

var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene
@onready var menu = $Menu/Menu
@onready var battle_layer = $BattleLayer
@onready var mart_view = $Mart_View
@onready var day_and_night = $DayAndNight

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
	POKEDEX,
	EXIT_POKEDEX,
	EXIT_EVOLUTION,
	TRAINER_BATTLE,
	EXIT_TRAINER_BATTLE,
	BATTLE_LOST
}
var transition_type = Transition_Type.NEW_SCENE

var save_file_path = "user://save/Scene/"
var save_file_name = "Scene.tres"

var summary_pokemon:int 

var pocket_monster:game_pokemon
var Map:int = 0
var WorldEnv:WorldEnvironment = null

signal data_set_finished
signal evolution_finished

signal trainer_battle_finished

var just_loaded:bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)
	load_data()
	#Dialogic.Save.load()
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
	current_healing_place = Scene_Saver.current_healing_place
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

func transistion_trainer_battle_scene(pokemons,map):
	Utils.get_player().set_physics_process(false)
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.TRAINER_BATTLE
	pocket_monster = pokemons[0]
	BattleManager.EnemyPokemons = pokemons
	Map = map
	
func transition_to_evolution():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EVOLUTION

func transistion_exit_evolution():
	menu.get_parent().show()
	re_check_evolution()
	Utils.get_player().switch_default_camera()

func transistion_exit_pokedex_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_POKEDEX
	
func transition_to_pokedex_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.POKEDEX


func transistion_exit_bag_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_BAG_SCENE
	
func transition_to_bag_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BAG_SCENE

func transistion_to_battle_scene(pokemon,map = 0):
	Utils.get_player().set_physics_process(false)
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BATTLE_SCENE
	pocket_monster = pokemon
	Map = map
	
func transistion_exit_battle_scene():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.EXIT_BATTLE_SCENE

func transistion_exit_battle_loast():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.BATTLE_LOST
	
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
			Utils.Tilemaps = []
			change_scene()
		Transition_Type.MENU_ONLY:
			menu.unload_party_screen()
		Transition_Type.PARTY_SCREEN:
			menu.load_party_screen()
		Transition_Type.SUMMARY_SCENE:
			menu.load_summary_screen(summary_pokemon)
		Transition_Type.EXIT_SUMMARY_SCENE:
			menu.unload_summary_screen()
		Transition_Type.BATTLE_SCENE:
			load_battle_scene(pocket_monster,Map)
			pocket_monster = null
			Map = 0
			AudioManager.switch_to_battle()
		Transition_Type.EXIT_BATTLE_SCENE:
			unload_battle_scene()
			AudioManager.switch_to_exploration()
		Transition_Type.BAG_SCENE:
			menu.load_bag_scene()
		Transition_Type.EXIT_BAG_SCENE:
			menu.unload_bag_scene()
			unload_bag_scene()
		Transition_Type.EVOLUTION:
			load_evolution()
		Transition_Type.EXIT_EVOLUTION:
			re_check_evolution()
		Transition_Type.TRAINER_BATTLE:
			load_battle_trainer(pocket_monster,Map)
			pocket_monster = null
			Map = 0
			AudioManager.switch_to_battle()
		Transition_Type.BATTLE_LOST:
			load_healing_place()
			AudioManager.switch_to_exploration()
		Transition_Type.POKEDEX:
			menu.load_pokedex()
		Transition_Type.EXIT_POKEDEX:
			menu.unload_pokedex()
	transition_player.play("FadeToNormal")

func change_scene():
	
	if current_scene.get_child(0).has_method("get_modulater"):
		current_scene.get_child(0).get_modulater().visible = false
		
	current_scene.get_child(0).queue_free()
#	for i in current_scene.get_child(0).get_children():
#		if i.has_method("remove_tilemap")
	current_scene.add_scene(load(next_scene))
	
	var player = Utils.get_player()
	Utils.set_player()
	player.set_spawn(player_location,player_direction)
	player.set_poke_pos_dir(player.global_position+Vector2(0,16),player.get_current_facing_direction())
	Utils.set_player(false)
	emit_signal("data_set_finished")
	
func load_healing_place():
	unload_battle_scene(false)
	
	if current_scene.get_child(0).has_method("get_modulater"):
		current_scene.get_child(0).get_modulater().visible = false
	
	current_scene.get_child(0).queue_free()
	
	var Current_healing_place
	
	if current_healing_place == null:
		Current_healing_place = default_healing_place.instantiate()
	else:
		Current_healing_place = load(current_healing_place).instantiate()
		
	current_scene.add_child(Current_healing_place)
	
	var player = Utils.get_player()
	Utils.set_player()
	player.set_spawn(Current_healing_place.get_heal_pos(),Current_healing_place.get_heal_dir())
	player.set_poke_pos_dir(player.global_position+Vector2(0,16),player.get_current_facing_direction())
	
	Current_healing_place.heal()
	
	
func load_battle_trainer(pokemon,map):
	TouchInput.toogele_default(false)
	TouchInput.toggle_battle(true)
	battle_layer.add_child(battle_scene.instantiate())
	battle_layer.get_child(0).set_enemy(pokemon)
	battle_layer.get_child(0).set_map(map)
	BattleManager.in_battle = true
	
	BattleManager.Trainer_Battle = true
	
func unload_bag_scene():
	if battle_layer.get_child_count() >0:
		battle_layer.get_child(0).exit_bag()
		menu.visible = false
	
func check_moves():
	emit_signal("evolution_finished")
	await EvolutionManager.evolution_done
	continue_check_evolution()
	
func re_check_evolution():
	if Global.auto_evolve == true:
		check_moves()
	else:
		done_with_evolution()
		
func done_with_evolution():
	if WorldEnv != null:
		WorldEnv.queue_free()
		WorldEnv = null
	
	EvolutionManager.done_evolving()
	Utils.get_player()._pokemon_evolved()
	menu.set_summary_active()
	
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
	
	if Global.auto_evolve == true:
		var EvolutionScreen = evolution_scene.instantiate()
		
		EvolutionScreen.set_pokemons(EvolutionManager.pokemon_to_evolve[0],EvolutionManager.evolving_pokemon[0])
		Utils.get_player().add_child(EvolutionScreen)
		Utils.get_player().switch_evolution_camera()
		EvolutionManager.evolve()
	else:
		var EvolutionScreen = evolution_scene.instantiate()
		EvolutionScreen.set_pokemons(EvolutionManager.Pokemon_to_evolve,EvolutionManager.Evolving_pokemon)
		Utils.get_player().add_child(EvolutionScreen)
		Utils.get_player().switch_evolution_camera()
		menu.get_parent().hide()
	
func load_battle_scene(pokemon,map):
	TouchInput.toogele_default(false)
	TouchInput.toggle_battle(true)
	battle_layer.add_child(battle_scene.instantiate())
	battle_layer.get_child(0).set_enemy(pokemon)
	battle_layer.get_child(0).set_map(map)
	BattleManager.in_battle = true
	
func unload_battle_scene(won:bool = true):
	TouchInput.toogele_default(true)
	TouchInput.toggle_battle(false)
	for i in battle_layer.get_children():
		i.queue_free()
	BattleManager.finish_battle()
	Utils.get_player().set_physics_process(true)
	Utils.get_player().finish_battle()
	BattleManager.in_battle = false
	
	if BattleManager.Trainer_Battle == true:
		BattleManager.Trainer_Battle = false
		if won == true:
			emit_signal("trainer_battle_finished")
	if Global.auto_evolve == true:
		AllyPokemon.check_evolution_all()
		print_debug("what the fuck")
	
	BattleManager.EnemyPokemons = []
func get_current_scene_name():
	return current_scene.get_child(0).name


func _on_current_scene_has_modulate():
	day_and_night.visible = false


func _on_current_scene_no_modulate():
	day_and_night.visible = true

func shoot_screen():
	var vpt :Viewport = get_viewport()
	var tex :Texture = vpt.get_texture()
	var img :Image = tex.get_image()
	img.save_png("user://save/Scene/"+"screenshot.png")

func set_current_healing_place(place):
	current_healing_place = place
	Scene_Saver.change_healing_place(current_healing_place)
