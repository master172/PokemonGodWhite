extends CharacterBody2D
class_name trainer

@export_group("Pokemons")
@export var pokemons:Array[Pokemon]
@export var levels :Array[int]
@export var current_dialog := ''
@export var ending_dialog := ''

@export_group("Animations")
@export var animation_player :AnimationPlayer
@export var animation_tree :AnimationTree
@export var sprite_2d :Sprite2D

@export_subgroup("FaceAt")
@export var looking_direction:Vector2 = Vector2(0,1)

@export_subgroup("Events")
@export var EventManager:Node2D
@export var map:int = 0
@onready var anim_state = animation_tree.get("parameters/playback")

var rng = RandomNumberGenerator.new()
var taliking = false

var can_battle:bool = true

var my_battle:bool = false
var my_battle_done:bool = false

signal battle_done
signal finished
signal talk(body)

var my_pokemons:Array[game_pokemon]

func _ready():
	basic_set()

func basic_set():
	for i in range(pokemons.size()):
		my_pokemons.append(game_pokemon.new(pokemons[i],levels[i]))
	if EventManager != null:
		EventManager.manage_events(self)
	if Utils.get_scene_manager() != null:
		Utils.get_scene_manager().connect("trainer_battle_finished",my_battle_finished)
	Dialogic.connect("signal_event",battle)
	Dialogic.connect("signal_event",no)
	Dialogic.connect("signal_event",end)
	Dialogic.connect("signal_event",finish)
	Dialogic.connect("signal_event",talking_end)
	look(looking_direction)

func talking_end(sign):
	if sign == "DialogicDone":
		get_viewport().set_input_as_handled()
		taliking = false
		
func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func walk_at(facDir:Vector2):
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",facDir)
	
func _interact():
	emit_signal("talk",self)
	if current_dialog != "" and taliking == false:
		if Utils.Player != null:
			Utils.Player.set_physics_process(false)
			
			taliking = true
			
			Dialogic.start(current_dialog)
			get_viewport().set_input_as_handled()
	

func battle(Sign):
	if Sign == "Battle" and taliking == true:
		my_battle = true
		Utils.get_scene_manager().transistion_trainer_battle_scene(my_pokemons,map)
		can_battle = false
		
func no(Sign):
	if Sign == "No" and taliking == true:
		Utils.get_player().set_physics_process(true)
		

func get_pokemon(num:int):
	var pokemon = my_pokemons[num]
	return pokemon

func end(Sign):
	if Sign == "end":
		taliking = false
		get_viewport().set_input_as_handled()


func my_battle_finished():
	if my_battle == true:
		Utils.aiden_defeated = true
		my_battle_done = true
		emit_signal("battle_done")

func finish(Sign):
	get_viewport().set_input_as_handled()
	if Sign == "DialogDone":
		Utils.save_data()
		Utils.Player.set_physics_process(true)
		await get_tree().create_timer(0.1).timeout
		taliking = false
		emit_signal("finished")
