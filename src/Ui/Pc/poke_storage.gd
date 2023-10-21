extends Control

const storage_item = preload("res://src/Ui/Pc/PokeStorage/storage_1.tscn")

@onready var pokemons = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer.get_children()
@onready var list_container = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer
@onready var search_bar = $VBoxContainer/MainContainer/Box/BoxContainer/Search/SearchBar
@onready var party_container = $VBoxContainer/MainContainer/Party/PartyContainer
@onready var cursor = $VBoxContainer/MainContainer/Box/BoxContainer/Search/Cursor
@onready var scroll_container = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer

var matches = []

enum states {
	SEARCH,
	LIST,
	PARTY,
	SEARCH_ACTIVE
}

var state = states.SEARCH

var current_selected:int = 0
var max_selectable:int = 6

func _ready():
	set_search_active()
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

func party_pokemon_clicked(num):
	print(num)

func set_search_bar_active():
	search_bar.grab_focus()

func set_party_active():
	party_container.get_child(current_selected).set_active(true)

func set_party_inactive():
	party_container.get_child(current_selected).set_active(false)

func set_search_active():
	cursor.visible = true

func set_search_inactive():
	cursor.visible = false
	
func _input(event):
	if event.is_action_pressed("W"):
		
		if state == states.LIST:
			if current_selected == 0:
				state = states.SEARCH
				set_search_active()
				set_list_inactive()
			else:
				set_list_inactive()
				current_selected  = (current_selected +max_selectable- 1) % max_selectable
				set_list_active()
				if current_selected > 6:
					scroll_container.scroll_vertical -= 68
				if current_selected == 0:
					scroll_container.scroll_vertical = 0
		elif state == states.PARTY:
			set_party_inactive()
			current_selected = (current_selected +max_selectable- 1) % max_selectable
			set_party_active()
			
			
	elif event.is_action_pressed("A"):
		if state == states.SEARCH:
			state = states.PARTY
			search_bar.release_focus()
			current_selected = 0
			max_selectable = 6
			set_party_active()
			set_search_inactive()
	elif event.is_action_pressed("S"):
		if state == states.PARTY:
			set_party_inactive()
			current_selected  = (current_selected +1) % max_selectable
			set_party_active()
			
		elif state == states.SEARCH:
			set_search_inactive()
			search_bar.release_focus()
			max_selectable = get_max_list()
			state = states.LIST

			current_selected = 0
			set_list_active()
		
		elif state == states.LIST:
			set_list_inactive()
			current_selected  = (current_selected +1) % max_selectable
			set_list_active()
			if current_selected > 7:
				scroll_container.scroll_vertical += 68
			if current_selected == 0:
				scroll_container.scroll_vertical = 0
	elif event.is_action_pressed("D"):
		if state == states.PARTY:
			state = states.SEARCH
			
			current_selected = 0
			max_selectable = 1
			set_party_inactive()
			set_search_active()
			
	elif event.is_action_pressed("Yes"):
		if not search_bar.has_focus():
			if state == states.SEARCH:
				search_bar.grab_focus()
				state = states.SEARCH_ACTIVE
				
		else:
			search_bar.release_focus()
			state = states.SEARCH

			
	elif event.is_action_pressed("No"):
		pass

func set_list_active():
	get_item_by_index(current_selected).change_selected(true)

func set_list_inactive():
	get_item_by_index(current_selected).change_selected(false)
	
func get_max_list():
	var num: int =0
	for i in list_container.get_children():
		if i.visible == true:
			num += 1
	return num

func get_item_by_index(num):
	num += 1
	for i in list_container.get_children():
		if i.visible == true:
			num -= 1
		if num == 0:
			return i
