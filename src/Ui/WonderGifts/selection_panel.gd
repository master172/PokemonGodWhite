extends Panel

signal no
signal yes(num:int,poke:game_pokemon)

var current_selected:int = 0
var selected_pokemon:game_pokemon

var max_selectable:int = 6

@onready var pokemon_sprite: TextureRect = $ConfirmPanel/VBoxContainer/PokeContainer/Pokemon

func start():
	max_selectable = AllyPokemon.get_Party_pokemon_size()
	if AllyPokemon.get_Party_pokemon_size() > 1:
		selected_pokemon = AllyPokemon.get_party_pokemon(0)
		current_selected = 0
	update()
	
func update():
	pokemon_sprite.texture = selected_pokemon.Base_Pokemon.get_front_sprite()

func _on_no_pressed() -> void:
	emit_signal("no")
	AudioManager.cancel()

func _on_left_pressed() -> void:
	current_selected  = (current_selected +max_selectable - 1) % max_selectable
	selected_pokemon = AllyPokemon.get_party_pokemon(current_selected)
	update()
	AudioManager.input()


func _on_right_pressed() -> void:
	current_selected = (current_selected + 1) % max_selectable
	selected_pokemon = AllyPokemon.get_party_pokemon(current_selected)
	update()
	AudioManager.input()

func _on_yes_pressed() -> void:
	if AllyPokemon.get_Party_pokemon_size() > 1:
		emit_signal("yes",current_selected,selected_pokemon)
		AudioManager.select()
