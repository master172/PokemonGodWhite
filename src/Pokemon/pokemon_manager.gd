extends Node2D

@onready var poke_sprite = $OverWorld/Anchor/PokeSprite
@onready var animation_player = $OverWorld/Anchor/AnimationPlayer

@export var pokemon :Pokemon

func _ready():
	poke_sprite.texture = pokemon.get_overworld_sprite()
