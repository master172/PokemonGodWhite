extends Node

const MainPikachu = preload("res://Core/Pokemon/MainPikachu.tres")
# Called when the node enters the scene tree for the first time.

func _ready():
	var mainPikachu :game_pokemon = game_pokemon.new(MainPikachu)
	AllyPokemon.add_pokemon(mainPikachu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
