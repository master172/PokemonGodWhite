extends HBoxContainer

var selected_pokemon:game_pokemon = null
var selected_index:int = -1

signal poke_changed(poke:game_pokemon,num:int)

var signals_set:bool = false

func update():
	for i :int in AllyPokemon.get_Party_pokemon_size():
		get_child(i).icon = AllyPokemon.get_party_pokemon(i).Base_Pokemon.get_front_sprite()
		if signals_set == false:
			get_child(i).pressed.connect(_on_button_pressed.bind(i))
	signals_set = true
	
func emit_poke_changes(poke:game_pokemon,num:int):
	poke_changed.emit(poke,num)

func _on_button_pressed(num:int):
	emit_poke_changes(AllyPokemon.get_party_pokemon(num),num)
