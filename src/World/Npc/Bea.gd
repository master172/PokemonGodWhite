extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D
@onready var canvas_player = $CanvasPlayer

@onready var anim_state  = animation_tree.get("parameters/playback")

@export var current_dialog:DialogueLine

func _ready():
	Dialogic.connect("signal_event",healing_done)
	Dialogic.connect("signal_event",start_first_heal)
	DialogLayer.get_child(0).connect("finished",finish)

func start_first_heal(sign):
	if sign == "FirstHeal":
		first_heal()

func first_heal():
	AllyPokemon.all_heal()
	canvas_player.play("Heal")
	
	
func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func _interact():
	if Utils.Bea_met == false:
		Utils.Bea_met = true
		Utils.get_player().set_physics_process(false)
		Dialogic.start('BeaFirst')
		get_viewport().set_input_as_handled()
	elif Utils.William_met == false:
		Utils.get_player().set_physics_process(false)
		Dialogic.start('GotoWilliam')
		get_viewport().set_input_as_handled()
	else:
		DialogLayer.get_child(0)._start(current_dialog)
	

func finish(dial):
	if dial == current_dialog:
		Utils.get_player().set_physics_process_custom(true)

func heal():
	look(Vector2(-1,0))
	Utils.get_player().set_physics_process(false)
	Dialogic.start('BeaHeal')

func healing_done(Sign):
	if Sign == "Done":
		Utils.get_player().set_physics_process_custom(true)
		Utils.autosave()
