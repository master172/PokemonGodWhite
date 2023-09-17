extends Control

const bag_node = preload("res://src/Ui/Bag/bag_node.tscn")
const reg_poke_sl = preload("res://assets/player/ash/Bag/pokeselector.png")
const reg_poke_ac = preload("res://assets/player/ash/Bag/pokeselector1.png")

var current_selected:int = 0
var max_selected:int = 9


@onready var general_items = $VBoxContainer/HBox/Bag/Rows/GeneralItems
@onready var medicine = $VBoxContainer/HBox/Bag/Rows/Medicine
@onready var battle_items = $VBoxContainer/HBox/Bag/Rows/BattleItems
@onready var pokeballs = $VBoxContainer/HBox/Bag/Rows/Pokeballs
@onready var machines = $VBoxContainer/HBox/Bag/Rows/Machines
@onready var berries = $VBoxContainer/HBox/Bag/Rows/Berries
@onready var key_items = $VBoxContainer/HBox/Bag/Rows/KeyItems
@onready var evolution = $VBoxContainer/HBox/Bag/Rows/Evolution
@onready var texture_rect_9 = $VBoxContainer/HBox/Bag/Rows/TextureRect9

@onready var scroll_container = $VBoxContainer/HBox/Bag/ScrollContainer
@onready var v_box_container = $VBoxContainer/HBox/Bag/ScrollContainer/VBoxContainer

@onready var icon_0 = $VBoxContainer/HBox/PokeContainer/Icon0
@onready var icon_1 = $VBoxContainer/HBox/PokeContainer/Icon1
@onready var icon_2 = $VBoxContainer/HBox/PokeContainer/Icon2
@onready var icon_3 = $VBoxContainer/HBox/PokeContainer/Icon3
@onready var icon_4 = $VBoxContainer/HBox/PokeContainer/Icon4
@onready var icon_5 = $VBoxContainer/HBox/PokeContainer/Icon5

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
	texture_rect_9,
]

@onready var Pokemons:Array = [
	icon_0,
	icon_1,
	icon_2,
	icon_3,
	icon_4,
	icon_5,
]
var itemScrollThreshold:int = 7

func _ready():
	set_pockets()
	
func set_pockets():
	Pockets[current_selected].self_modulate = Color(0, 0.522, 1)

func set_pockets_active():
	Pockets[current_selected].self_modulate = Color(0, 1, 0.271)

func unset_pockets():
	Pockets[current_selected].self_modulate = Color(1, 1, 1)

func unset_item():
	v_box_container.get_child(current_selected).active = false
	
func set_item():
	v_box_container.get_child(current_selected).active = true

func set_pokemon():
	Pokemons[current_selected].texture = reg_poke_ac

func unset_pokemon():
	Pokemons[current_selected].texture = reg_poke_sl
	
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
		if state == STATES.NORMAL:
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
