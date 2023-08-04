extends Node2D

@onready var marker_2d = $Marker2D
@onready var ally_pokemon = $AllyPokemon

const battle_pokemon = preload("res://Core/Battle/battle_pokemon.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_hud_pokemon_selected(pokemon):
	var BATTLE_POKEMON = battle_pokemon.instantiate()
	BATTLE_POKEMON.pokemon = AllyPokemon.get_party_pokemon(pokemon)
	BATTLE_POKEMON.position = marker_2d.position
	ally_pokemon.add_child(BATTLE_POKEMON)
	BattleManager.AllyPokemons.add_pokemon(AllyPokemon.get_party_pokemon(pokemon))
