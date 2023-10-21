extends Control

const storage_item = preload("res://src/Ui/Pc/PokeStorage/storage_1.tscn")
@onready var pokemons = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer.get_children()
@onready var list_container = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer

var matches = []

func _ready():
	if AllyPokemon.get_pcPokemonSize() > 0:
		for i in AllyPokemon.get_PcPokemons():
			var S = storage_item.instantiate()
			S.set_pokemon(i)
			list_container.add_child(S)
	pokemons = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer.get_children()
func _on_search_bar_text_changed(new_text):
	new_text = new_text.to_lower()
	
	if new_text == "":
		for i in pokemons:
			i.show()
		return
	matches.clear()
	
	for i in pokemons:
		if new_text in i.get_pokename().to_lower():
			matches.append(i)
	for i in pokemons:
		if i in matches:
			i.show()
		else:
			i.hide()
