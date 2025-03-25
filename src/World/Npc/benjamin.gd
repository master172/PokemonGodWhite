extends CharacterBody2D
class_name TraderNpc

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D

@onready var anim_state  = animation_tree.get("parameters/playback")

@export var start_dialog:String
@export var trade_done_dialog:String
@export var trade_reject_dialog:String
@export var trade_finish_dialog:String

@export var my_pokemon:Pokemon = null
@export var required_pokemon:Pokemon = null
@export var desired_level:int = 12

var pokemon:game_pokemon = null

var traded:bool = false
var trade_accepted:bool = false

var interacting:bool = false

func _ready():
	Dialogic.connect("signal_event",trade)
	Dialogic.connect("timeline_ended",end)
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
	interacting = true
	Utils.get_player().set_physics_process(false)
	if Global.has_var(self.name,"traded"):
		traded = Global.load_var(self.name,"traded")
	if traded == false:
		Dialogic.start(start_dialog)
	else:
		Dialogic.start(trade_done_dialog)

func end():
	if not interacting:
		return
	if traded == true:
		trade_accepted = false
	if trade_accepted == false:
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process_custom(true)
		Utils.Menu.lock = false
		interacting = false
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
		print("traded ", traded)
		Global.save_var(self.name,"traded",traded)
		AllyPokemon.trade_pokemon(num,pokemon)
		var selector = Utils.get_scene_manager().selector
		selector.stop()
		Dialogic.start(trade_finish_dialog)
	else:
		trade_accepted = false
		var selector = Utils.get_scene_manager().selector
		selector.stop()
		Dialogic.start("trade_reject")
		reset_connections()

func canceled():
	trade_accepted = false
	Dialogic.start("trade_cancel")
