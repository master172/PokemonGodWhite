extends Node2D

@onready var poke_sprite = $OverWorld/Anchor/PokeSprite
@onready var animation_player = $OverWorld/Anchor/AnimationPlayer
@onready var animation_tree = $OverWorld/Anchor/AnimationTree
@onready var anim_state  = animation_tree.get("parameters/playback")
@export var pokemon :Pokemon

var direction:Vector2 = Vector2.ZERO

func _ready():
	anim_state.travel("Walk")
	poke_sprite.texture = pokemon.get_overworld_sprite()

func set_direction(Direction):
	direction = Direction
	animation_tree.set("parameters/Walk/blend_position",direction)
