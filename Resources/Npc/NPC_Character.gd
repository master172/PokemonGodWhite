@tool
extends CharacterBody2D
class_name NPC_Character

@export var Npc:NPC = null:
	set = set_npc
@onready var Sprite:Sprite2D = $Sprite2D

func set_npc(value):
	Npc = value
	if Npc != null:
		if Sprite != null:
			Sprite.texture = Npc.Sprite
	else:
		Sprite.texture = null

func _interact():
	print("hi")
