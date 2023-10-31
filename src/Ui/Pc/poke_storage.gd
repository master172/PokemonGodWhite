extends Control

const storage_item = preload("res://src/Ui/Pc/PokeStorage/storage_1.tscn")

@onready var list_container = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer/ListContainer
@onready var search_bar = $VBoxContainer/MainContainer/Box/BoxContainer/Search/SearchBar
@onready var party_container = $VBoxContainer/MainContainer/Party/PartyContainer
@onready var cursor = $VBoxContainer/MainContainer/Box/BoxContainer/Search/Cursor
@onready var scroll_container = $VBoxContainer/MainContainer/Box/BoxContainer/List/ScrollContainer
@onready var quit_panel = $QuitPanel

var matches = []

enum states {
	SEARCH,
	LIST,
	PARTY,
	SEARCH_ACTIVE,
	SWITCHING,
	QUITING
}

var state = states.SEARCH

var current_selected:int = 0
var max_selectable:int = 6

var pc_switch_index :int = 0

var previous_state
var previous_selected

signal quit_active
signal quit_cancel
signal Quit

func _ready():
	set_search_active()
	if AllyPokemon.get_pcPokemonSize() > 0:
		for i in AllyPokemon.get_PcPokemons():
			var S = storage_item.instantiate()
			S.set_pokemon(i)
			list_container.add_child(S)
	#

func _on_search_bar_text_changed(new_text):
		
	new_text = new_text.to_lower()
	
	if new_text == "":
		for i in list_container.get_children():
			i.show()
		return
	matches.clear()
	
	for i in list_container.get_children():
		if new_text in i.get_pokename().to_lower():
			matches.append(i)
	for i in list_container.get_children():
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
		AudioManager.input()
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
		
		elif state == states.SWITCHING:
			set_party_inactive()
			current_selected = (current_selected +max_selectable- 1) % max_selectable
			set_party_active()
			
	elif event.is_action_pressed("A"):
		AudioManager.input()
		if state == states.SEARCH:
			state = states.PARTY
			search_bar.release_focus()
			current_selected = 0
			max_selectable = 6
			set_party_active()
			set_search_inactive()
			
		elif state == states.QUITING:
			current_selected  = (current_selected +1) % max_selectable
			quit_panel.set_active(current_selected)
		
		elif state == states.LIST:
			set_list_inactive()
			current_selected = 0
			max_selectable = 6
			state = states.PARTY
			set_party_active() 
			
	elif event.is_action_pressed("S"):
		AudioManager.input()
		if state == states.PARTY:
			set_party_inactive()
			current_selected  = (current_selected +1) % max_selectable
			set_party_active()
		
		elif state == states.SWITCHING:
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
		AudioManager.input()
		if state == states.PARTY:
			state = states.SEARCH
			set_party_inactive()
			current_selected = 0
			max_selectable = 1
			
			set_search_active()
		elif state == states.QUITING:

			current_selected = (current_selected +max_selectable- 1) % max_selectable
			quit_panel.set_active(current_selected)
			
	elif event.is_action_pressed("Yes"):
		AudioManager.select()
		if state == states.SEARCH:
			if not search_bar.has_focus():
				search_bar.grab_focus()
				state = states.SEARCH_ACTIVE
				
		elif state == states.SEARCH_ACTIVE:
			search_bar.release_focus()
			state = states.SEARCH

		elif state == states.PARTY:
			if AllyPokemon.get_Party_pokemon_size() > 1:
				AllyPokemon.deposit(current_selected)

				update_deposit()
			
		elif state == states.LIST:
			if AllyPokemon.get_Party_pokemon_size() < 6:

				AllyPokemon.withdraw(get_item_index(current_selected))
				update_withdraw(current_selected)
				
				if current_selected > 0:
					current_selected -= 1
			
			
				print(current_selected)
				max_selectable = get_max_list()
				await get_tree().create_timer(0.1).timeout
				set_list_active()
			else:
				pc_switch_index = current_selected
				current_selected = 0
				set_party_active()
				max_selectable = 6
				state = states.SWITCHING
				
		elif state == states.SWITCHING:
				AllyPokemon.Pc2Party_pokemon_switch(current_selected,get_item_index(pc_switch_index))
				update_switch()
				set_party_inactive()
				current_selected = pc_switch_index
				pc_switch_index = 0
				state = states.LIST
				max_selectable = get_max_list()
		
		elif state == states.QUITING:
			if current_selected == 0:
				quit_panel.quit()
			elif current_selected == 1:
				emit_signal("quit_cancel")
				state = previous_state
				current_selected = previous_selected
				max_selectable = 1
				previous_selected = 0
				previous_state = 0
				
				
	elif event.is_action_pressed("No"):
		AudioManager.cancel()
		if state == states.SWITCHING:
			set_party_inactive()
			current_selected = pc_switch_index
			state = states.LIST
			max_selectable = get_max_list()
		else:
			previous_state = state
			state = states.QUITING
			previous_selected = current_selected
			
			current_selected = 0
			max_selectable = 2
			emit_signal("quit_active")
			

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

func get_item_index(num):
	num += 1
	for i in list_container.get_child_count():
		if list_container.get_child(i).visible == true:
			num -= 1
		if num == 0:
			return i
			
func update_deposit():
	for i in party_container.get_children():
		i.update()
		
	var at:int = AllyPokemon.get_pcPokemonSize()
	
	var S = storage_item.instantiate()
	S.set_pokemon(AllyPokemon.get_pcPokemon(at - 1))
	list_container.add_child(S)
	
func update_switch():
	for i in party_container.get_children():
		i.update()
	
	print(pc_switch_index)
	get_item_by_index(pc_switch_index).pokemon = AllyPokemon.get_pcPokemon(get_item_index(pc_switch_index))
	get_item_by_index(pc_switch_index).update()
	
#func print_party():
#	for i in AllyPokemon.get_party_pokemons():
#		print(i.Nick_name)
#
#func print_pc():
#	for i in AllyPokemon.get_PcPokemons():
#		print(i.Nick_name)
		
func update_withdraw(at:int):
	
	get_item_by_index(at).queue_free()

	
	for i in party_container.get_children():
		i.update()



func _on_quit_panel_quit():
	emit_signal("Quit")
