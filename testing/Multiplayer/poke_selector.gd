extends Control

signal poke_changed(poke:game_pokemon)

@onready var options: OptionButton = $Options

var pokemons:Array[game_pokemon] = []

func _ready() -> void:
	for i :game_pokemon in AllyPokemon.get_party_pokemons():
		pokemons.append(i)
		options.add_item(i.Nick_name)


func _on_options_item_selected(index: int) -> void:
	emit_signal("poke_changed",pokemons[index])
