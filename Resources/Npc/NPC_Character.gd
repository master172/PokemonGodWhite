@tool
extends CharacterBody2D
class_name NPC_Character

@export var Npc:NPC = null:
	set = set_npc
@onready var Sprite:Sprite2D = $Sprite2D

@export var current_dialog:DialogueLine

func set_npc(value):
	Npc = value
	if Npc != null:
		if Sprite != null:
			Sprite.texture = Npc.Sprite
	else:
		Sprite.texture = null

func _interact():
	DialogLayer.get_child(0)._start(current_dialog)
	DialogLayer.get_child(0).connect("finished",finish)

func finish(dial):
	if dial == current_dialog:
		Utils.get_player().set_physics_process(true)
