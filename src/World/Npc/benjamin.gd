extends CharacterBody2D
class_name TraderNpc

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D

@onready var anim_state  = animation_tree.get("parameters/playback")

@export var current_dialog:String
@export var trade_done_dialog:String
@export var trade_reject_dialog:String

@export var my_pokemon:Pokemon = null
@export var required_pokemon:Pokemon = null
@export var desired_level:int = 12

var pokemon:game_pokemon = null

var traded:bool = false
var trade_accepted:bool = false

func _ready():
	Dialogic.connect("signal_event",trade)
	Dialogic.connect("timeline_ended",end)
	Global.save_var("traded",traded)
	create_pokemon()
	
func create_pokemon():
	if my_pokemon != null:
		pokemon = game_pokemon.new(my_pokemon,desired_level)
	
func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func trade(Sign:String):
	if Sign == "SaidYes":
		trade_accepted = true
	elif Sign == "SaidNo":
		trade_accepted = false
	
func _interact():
	Utils.get_player().set_physics_process(false)
	traded = Global.load_var("traded")
	if traded == false:
		Dialogic.start(current_dialog)
	else:
		Dialogic.start(trade_done_dialog)

func end():
	if traded == true:
		trade_accepted = false
	if trade_accepted == false:
		print("is this the cause")
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process(true)
		Utils.Menu.lock = false
	elif trade_accepted == true:
		set_connections()


func set_connections():
	var selector = Utils.get_scene_manager().selector
	if selector != null:
		selector.select.connect(pokemon_selected)
		selector.cancel.connect(canceled)
	selector.start()
	
func reset_connections():
	var selector = Utils.get_scene_manager().selector
	if selector != null:
		selector.select.disconnect(pokemon_selected)
		selector.cancel.disconnect(canceled)
		
func pokemon_selected(num:int):
	if AllyPokemon.get_party_pokemon(num).Base_Pokemon == required_pokemon:
		traded = true
		Global.save_var("traded",traded)
		AllyPokemon.trade_pokemon(num,pokemon)
		end()
	else:
		trade_accepted = false
		var selector = Utils.get_scene_manager().selector
		selector.stop()
		Dialogic.start("trade_reject")

func canceled():
	trade_accepted = false
	Dialogic.start("trade_cancel")
