extends Control

const bag_node = preload("res://src/Ui/Bag/bag_node.tscn")

var current_selected:int = 0
var max_selected:int = 9

@onready var poke_container = $VBoxContainer/HBox/PokeContainer

@onready var general_items = $VBoxContainer/HBox/Bag/Rows/General_Items
@onready var medicine = $VBoxContainer/HBox/Bag/Rows/Medicine
@onready var battle_items = $VBoxContainer/HBox/Bag/Rows/Battle_Items
@onready var pokeballs = $VBoxContainer/HBox/Bag/Rows/PokeBalls
@onready var machines = $VBoxContainer/HBox/Bag/Rows/Machines
@onready var berries = $VBoxContainer/HBox/Bag/Rows/Berries
@onready var key_items = $VBoxContainer/HBox/Bag/Rows/KeyItems
@onready var evolution = $VBoxContainer/HBox/Bag/Rows/Evolution
@onready var trophys = $VBoxContainer/HBox/Bag/Rows/Trophys

@onready var scroll_container = $VBoxContainer/HBox/Bag/ScrollContainer
@onready var v_box_container = $VBoxContainer/HBox/Bag/ScrollContainer/VBoxContainer

@onready var icon_0 = $VBoxContainer/HBox/PokeContainer/Icon0
@onready var icon_1 = $VBoxContainer/HBox/PokeContainer/Icon1
@onready var icon_2 = $VBoxContainer/HBox/PokeContainer/Icon2
@onready var icon_3 = $VBoxContainer/HBox/PokeContainer/Icon3
@onready var icon_4 = $VBoxContainer/HBox/PokeContainer/Icon4
@onready var icon_5 = $VBoxContainer/HBox/PokeContainer/Icon5

@onready var label = $VBoxContainer/HBox/Bag/Label

@onready var item_name = $VBoxContainer/HBox/Bag/Text/HBoxContainer/ColorRect/Label
@onready var rich_text_label = $VBoxContainer/HBox/Bag/Text/HBoxContainer/RichTextLabel

@onready var options_container = $OptionsContainer
@onready var Money = $VBoxContainer/VSeparator/HBoxContainer/Money

enum STATES {
	NORMAL,
	POKEMON,
	ITEMS,
	SELECTION
}

enum ITEM_STATES {
	NONE,
	USING,
	GIVING,
	THROWING,
}

var current_item_state = ITEM_STATES.NONE

var state:=STATES.NORMAL
var bagkey:int = 0
var itemkey:int = 0
var pokekey:int = 0

@onready var Pockets:Array = [
	general_items,
	medicine,
	battle_items,
	pokeballs,
	machines,
	berries,
	key_items,
	evolution,
	trophys,
]

@onready var Pokemons:Array = [
	icon_0,
	icon_1,
	icon_2,
	icon_3,
	icon_4,
	icon_5,
]

var hints:Dictionary = {
	0:"general_items",
	1:"Medicine",
	2:"BattleItems",
	3:"Pokeballs",
	4:"Machines",
	5:"Berries",
	6:"KeyItems",
	7:"Evolution",
	8:"Trophys"
}

var current_pocket = null
var itemScrollThreshold:int = 10

var current_item:int = 0

func _ready():
	_unset_selection()
	set_pockets()
	clear_items()
	Money.text = "YOUR MONEY : $ " + str(Utils.Money)
	
func set_pockets():
	clear_items()
	Pockets[current_selected].self_modulate = Color(0, 0.522, 1)
	add_items()
	
func set_pockets_active():
	Pockets[current_selected].self_modulate = Color(0, 1, 0.271)

func unset_pockets():
	clear_items()
	Pockets[current_selected].self_modulate = Color(1, 1, 1)

func unset_item():
	clear_data()
	if v_box_container.get_child_count() >0:
		v_box_container.get_child(current_selected).active = false
	
func set_item():
	clear_data()
	v_box_container.get_child(current_selected).active = true
	set_data(Inventory.pocket.pockets[current_pocket].items[current_selected])
	
func set_pokemon():
	Pokemons[current_selected].set_active(true)

func unset_pokemon():
	Pokemons[current_selected].set_active(false)
	
func _input(event):
	if event.is_action_pressed("A"):
		AudioManager.input()
		if state == STATES.NORMAL:
			unset_pockets()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			set_pockets()
	elif event.is_action_pressed("D"):
		AudioManager.input()
		if state == STATES.NORMAL:
			unset_pockets()
			current_selected = (current_selected + 1) %max_selected
			set_pockets()
	elif event.is_action_pressed("S"):
		AudioManager.input()
		if state == STATES.NORMAL and v_box_container.get_child_count() > 0:
			state = STATES.ITEMS
			max_selected = v_box_container.get_child_count()
			bagkey = current_selected
			set_pockets_active()
			current_selected = 0
			set_item()
			scroll_container.scroll_vertical = 0
		elif state == STATES.ITEMS:
			unset_item()
			current_selected = (current_selected + 1) % max_selected
			
			if current_selected >= itemScrollThreshold:
				scroll_container.scroll_vertical += 64
			else:
				scroll_container.scroll_vertical = 0
			set_item()
		elif state == STATES.SELECTION:
			options_container._unset_selected(current_selected)
			current_selected = (current_selected + 1) % max_selected
			options_container._set_selected(current_selected)
		
		elif state == STATES.POKEMON:
			unset_pokemon()
			current_selected = (current_selected + 1) % max_selected
			set_pokemon()
			
	elif event.is_action_pressed("W"):
		AudioManager.input()
		if state == STATES.ITEMS:
			if current_selected == 0:
				state = STATES.NORMAL
				max_selected = 9
				unset_item()
				current_selected = bagkey
				bagkey = 0
				set_pockets()
			else:
				unset_item()
				current_selected  = (current_selected +max_selected - 1) % max_selected
				
				if current_selected >= itemScrollThreshold:
					scroll_container.scroll_vertical -= 64
				else:
					scroll_container.scroll_vertical = 0
				set_item()
		elif state == STATES.SELECTION:
			options_container._unset_selected(current_selected)
			current_selected  = (current_selected +max_selected - 1) % max_selected
			options_container._set_selected(current_selected)
		
		elif state == STATES.POKEMON:
			unset_pokemon()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			set_pokemon()
	elif event.is_action_pressed("Yes"):
		AudioManager.select()
		if state == STATES.ITEMS:
			current_item = current_selected
			itemkey = current_selected
			state = STATES.SELECTION
			max_selected = 3
			current_selected = 0
			_set_selection()
		elif state == STATES.SELECTION:
			match current_selected:
				0:
					var ci = Inventory.pocket.pockets[current_pocket].items[current_item]
					if ci.item != null:
						if ci.item.get_function() == 0 or ci.item.get_function() == 1:
							max_selected = 6
							current_item_state = ITEM_STATES.USING
							_unset_selection()
							state = STATES.POKEMON
							current_selected = pokekey
							set_pokemon()
						elif ci.item.get_function() == 2:
							ci.use(current_selected)
							handle_item_use_closing()
							
				1:
					var ci :BaseItem= Inventory.pocket.pockets[current_pocket].items[current_item]
					if ci.held_item_file != "":
						max_selected = 6
						current_item_state = ITEM_STATES.GIVING
						_unset_selection()
						state = STATES.POKEMON
						current_selected = pokekey
						set_pokemon()
				2:
					pass
		elif state == STATES.POKEMON:
			if Inventory.pocket.pockets[current_pocket].items.size() > current_item:
				var ci :BaseItem = Inventory.pocket.pockets[current_pocket].items[current_item]
				if current_item_state == ITEM_STATES.USING:
					if AllyPokemon.get_party_pokemon(current_selected) != null:
						ci.use(current_selected)
						poke_container._all_display()
						clear_items()
						var temp = current_selected

						current_selected = bagkey
						add_items()
						current_selected = temp
						clear_data()

				elif current_item_state == ITEM_STATES.GIVING:
					if AllyPokemon.get_party_pokemon(current_selected) != null:
						AllyPokemon.get_party_pokemon(current_selected).take_item(ci.duplicate())
						ci.set_count(-1)
						poke_container._all_display()
						clear_items()
						var temp = current_selected
						
						current_selected = bagkey
						add_items()
						current_selected = temp
						clear_data()
	elif event.is_action_pressed("No"):
		AudioManager.cancel()
		if state == STATES.POKEMON:
			if v_box_container.get_child_count() > 0:
				state = STATES.ITEMS
				current_item_state = ITEM_STATES.NONE
				max_selected = v_box_container.get_child_count()
				unset_pokemon()
				pokekey = current_selected
				current_selected = itemkey
				itemkey = 0
			else:
				state = STATES.NORMAL
				max_selected = 9
				unset_pokemon()
				
				current_selected = bagkey
				set_pockets()
				bagkey = 0
		elif state == STATES.ITEMS or state == STATES.NORMAL:
			Utils.get_scene_manager().transition_exit_bag_scene()
		elif state == STATES.SELECTION:
			_unset_selection()
			state = STATES.ITEMS
			current_selected = itemkey
			itemkey = 0
			

func handle_item_use_closing():
	clear_items()
	current_selected = bagkey
	add_items()
	
	await get_tree().process_frame
	if v_box_container.get_child_count() > 0:
		state = STATES.ITEMS
		current_item_state = ITEM_STATES.NONE
		
		max_selected = v_box_container.get_child_count()
		current_selected = itemkey
		itemkey = 0
		_unset_selection()
		set_item()
	else:
		current_selected = 0
		_unset_selection()
		clear_data()
		state = STATES.NORMAL
		max_selected = 9
		current_selected = bagkey
		set_pockets()
		bagkey = 0
	
	
func clear_items():
	for i in v_box_container.get_children():
		i.queue_free()
		current_pocket = null

func add_items():
	current_pocket = Inventory.pocket.pockets[hints[current_selected]].type_Hint
	label.text = Inventory.pocket.pockets[hints[current_selected]].type_Hint
	for i in Inventory.pocket.pockets[hints[current_selected]].items:
		
		var Bag_node = bag_node.instantiate()
		
		v_box_container.add_child(Bag_node)
		Bag_node.set_item(i)

func set_data(item:BaseItem):
	item_name.text = item.Name
	rich_text_label.text = item.Description

func clear_data():
	item_name.text = ""
	rich_text_label.text = ""

func _set_selection():
	options_container.show()
	options_container._set_selected(current_selected)

func _unset_selection():
	options_container.hide()
	options_container._unset_selected(current_selected)
