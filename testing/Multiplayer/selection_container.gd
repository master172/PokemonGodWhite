extends HBoxContainer

var selected_pokemon:game_pokemon = null
var selected_index:int = -1

signal poke_changed(poke:game_pokemon,num:int)


func update():
	for i :int in AllyPokemon.get_Party_pokemon_size():
		get_child(i).icon = AllyPokemon.get_party_pokemon(i).Base_Pokemon.get_front_sprite()
		get_child(i).pressed.connect(_on_button_pressed.bind(i))

func update_without_signals():
	for i :int in AllyPokemon.get_Party_pokemon_size():
		get_child(i).icon = AllyPokemon.get_party_pokemon(i).Base_Pokemon.get_front_sprite()

func emit_poke_changes(poke:game_pokemon,num:int):
	poke_changed.emit(poke,num)

func _on_button_pressed(num:int):
	emit_poke_changes(AllyPokemon.get_party_pokemon(num),num)
