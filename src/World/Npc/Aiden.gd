extends CharacterBody2D
class_name trainer

@export_group("Pokemons")
@export var pokemons:Array[Pokemon]
@export var levels :Array[int]
@export var current_dialog := ''


@export_group("Animations")
@export var animation_player :AnimationPlayer
@export var animation_tree :AnimationTree
@export var sprite_2d :Sprite2D

@export_subgroup("FaceAt")
@export var looking_direction:Vector2 = Vector2(0,1)


@onready var anim_state = animation_tree.get("parameters/playback")

var rng = RandomNumberGenerator.new()
var taliking = false

var can_battle:bool = true

func _ready():
	Dialogic.connect("signal_event",battle)
	Dialogic.connect("signal_event",no)
	Dialogic.connect("signal_event",end)
	
	look(looking_direction)

func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func walk_at(facDir:Vector2):
	anim_state.travel("Walk")
	animation_tree.set("parameters/Walk/blend_position",facDir)
	
func _interact():
	if current_dialog != "" and can_battle == true:
		if Utils.Player != null:
			Utils.Player.set_physics_process(false)
		
		taliking = true
		Dialogic.start(current_dialog)
		get_viewport().set_input_as_handled()

func battle(Sign):
	if Sign == "Battle" and taliking == true:
		Utils.get_scene_manager().transistion_trainer_battle_scene(pokemons,levels)
		can_battle = false
	
func no(Sign):
	if Sign == "No" and taliking == true:
		Utils.get_player().set_physics_process(true)
		

func get_pokemon(num:int):
	var pokemon = pokemons[num]
	var poke_data = [pokemon,levels[num]]
	return poke_data

func end(Sign):
	if Sign == "end":
		taliking = false
		get_viewport().set_input_as_handled()

