extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D

@onready var anim_state  = animation_tree.get("parameters/playback")

@export var current_dialog:DialogueLine

func _ready():
	DialogLayer.get_child(0).connect("finished",finish)
	
func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)

func _interact():
	DialogLayer.get_child(0)._start(current_dialog)
	

func finish(dial):
	if dial == current_dialog:
		Utils.get_player().set_physics_process(true)
		
