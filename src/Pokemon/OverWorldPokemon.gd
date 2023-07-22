extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var poke_sprite = $PokeSprite

@onready var anim_state  = animation_tree.get("parameters/playback")
@export var pokemon :Pokemon

var direction:Vector2 = Vector2.ZERO

func _ready():
	anim_state.travel("Walk")
	poke_sprite.texture = pokemon.get_overworld_sprite()

func set_direction(Direction):
	direction = Direction
	animation_tree.set("parameters/Walk/blend_position",direction)
