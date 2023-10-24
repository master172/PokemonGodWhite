extends CharacterBody2D
class_name trainer

@export var pokemons:Array[Pokemon]
@export var levels :Array[int]
@export var current_dialog := ''

var rng = RandomNumberGenerator.new()
var taliking = false

@export var animation_player :AnimationPlayer
@export var animation_tree :AnimationTree
@export var sprite_2d :Sprite2D

@onready var anim_state = animation_tree.get("parameters/playback")


func _ready():
	Dialogic.connect("signal_event",battle)
	Dialogic.connect("signal_event",no)
	Dialogic.connect("signal_event",end)

func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func _interact():
	if current_dialog != "":
		if Utils.Player != null:
			Utils.Player.set_physics_process(false)
		
		taliking = true
		Dialogic.start(current_dialog)
		get_viewport().set_input_as_handled()

func battle(Sign):
	if Sign == "Battle" and taliking == true:
		var pokemon = get_main_pokemon()
		Utils.get_scene_manager().transistion_trainer_battle_scene(pokemon,pokemons,levels)
	

func no(Sign):
	if Sign == "No" and taliking == true:
		Utils.get_player().set_physics_process(true)
		
func get_main_pokemon():
	var pokemon = pokemons[0]
	var poke_data = [pokemon,levels[0]]
	return poke_data

func get_pokemon(num:int):
	var pokemon = pokemons[num]
	var poke_data = [pokemon,levels[num]]
	return poke_data

func end(Sign):
	if Sign == "end":
		taliking = false
