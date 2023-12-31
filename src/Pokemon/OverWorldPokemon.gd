extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var animation_tree = $AnimationTree
@onready var poke_sprite = $PokeSprite

@onready var anim_state  = animation_tree.get("parameters/playback")
@export var pokemon :game_pokemon

var direction:Vector2 = Vector2.ZERO

func _ready():
	var mainPokemon = AllyPokemon.get_main_pokemon()
	if mainPokemon != null:
		pokemon = mainPokemon
	anim_state.travel("Walk")
	poke_sprite.texture = pokemon.get_overworld_sprite()

func update():
	var mainPokemon = AllyPokemon.get_main_pokemon()
	if mainPokemon != null:
		pokemon = mainPokemon
	poke_sprite.texture = pokemon.get_overworld_sprite()
	
func set_direction(Direction):
	direction = Direction
	animation_tree.set("parameters/Walk/blend_position",direction)
