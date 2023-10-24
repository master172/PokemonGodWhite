extends CharacterBody2D

@export var pokemons:Array[Pokemon]
@export var levels :Array[int]

var rng = RandomNumberGenerator.new()

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D

@onready var anim_state  = animation_tree.get("parameters/playback")



const aiden_timeline = preload("res://src/Dialogs/AidenInteraction.dtl")

func _ready():
	Dialogic.connect("signal_event",battle)
	Dialogic.connect("signal_event",no)


func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func _interact():
	
	if Utils.Player != null:
		Utils.Player.set_physics_process(false)
		
	Dialogic.start('AidenInteraction')
	get_viewport().set_input_as_handled()

func battle(Sign):
	if Sign == "Battle" and Dialogic.current_timeline == aiden_timeline:
		var pokemon = get_main_pokemon()
		Utils.get_scene_manager().transistion_trainer_battle_scene(pokemon,pokemons,levels)
	

func no(Sign):
	if Sign == "No" and Dialogic.current_timeline == aiden_timeline:
		Utils.get_player().set_physics_process(true)
		
func get_main_pokemon():
	var pokemon = pokemons[0]
	var poke_data = [pokemon,levels[0]]
	return poke_data

func get_pokemon(num:int):
	var pokemon = pokemons[num]
	var poke_data = [pokemon,levels[num]]
	return poke_data
