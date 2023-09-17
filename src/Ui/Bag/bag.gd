extends Control

const bag_node = preload("res://src/Ui/Bag/bag_node.tscn")

var current_selected:int = 0
var max_selected:int = 9


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

enum STATES {
	NORMAL,
	POKEMON,
	ITEMS,
	SELECTION
}

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
var itemScrollThreshold:int = 7

func _ready():
	set_pockets()
	clear_items()
	
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
		if state == STATES.NORMAL:
			unset_pockets()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			set_pockets()
	elif event.is_action_pressed("D"):
		if state == STATES.NORMAL:
			unset_pockets()
			current_selected = (current_selected + 1) %max_selected
			set_pockets()
	elif event.is_action_pressed("S"):
		if state == STATES.NORMAL and v_box_container.get_child_count() != 0:
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
		
		elif state == STATES.POKEMON:
			unset_pokemon()
			current_selected = (current_selected + 1) % max_selected
			set_pokemon()
			
	elif event.is_action_pressed("W"):
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
		
		elif state == STATES.POKEMON:
			unset_pokemon()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			set_pokemon()
	elif event.is_action_pressed("Yes"):
		if state == STATES.ITEMS:
			itemkey = current_selected
			state = STATES.POKEMON
			max_selected = 6
			current_selected = pokekey
			pokekey = 0
			set_pokemon()
			
	elif event.is_action_pressed("No"):
		if state == STATES.POKEMON:
			state = STATES.ITEMS
			max_selected = v_box_container.get_child_count()
			unset_pokemon()
			pokekey = current_selected
			current_selected = itemkey
			itemkey = 0
		elif state == STATES.ITEMS or state == STATES.NORMAL:
			Utils.get_scene_manager().transistion_exit_bag_scene()
	
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
