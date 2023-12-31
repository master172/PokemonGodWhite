extends CharacterBody2D
class_name BaseTrainer
const TRAINER_BASE_ORDER = preload("res://src/Npc/Base/trainer_base_order.tscn")

@export var TrainerResource:NewTrainer
@export var Looking_direction:Vector2 = Vector2(0,1)

var event_component
var TrainerSkin
var battle_component
var Losing_component
var start_lose_component

var my_pokemons:Array[game_pokemon]

@export var Pokemons:Array[Pokemon]
@export var levels:Array[int]
@export var map:int = 0
@export var event_list:EventList = EventList.new()
@export var losing_event_list:EventList = EventList.new()

signal cannot_battle

func _ready():
	add_nodes()
	look(Looking_direction)
	add_pokemon()
	check_can_battle()
	
func check_can_battle():
	pass
		
func add_pokemon():
	for i in range(Pokemons.size()):
		my_pokemons.append(game_pokemon.new(Pokemons[i],levels[i]))
		
func add_nodes():
	self.add_child(TRAINER_BASE_ORDER.instantiate())

func GetTrainerResource():
	return TrainerResource

func _interact():
	if event_component != null:
		get_viewport().set_input_as_handled()
		check_for_event_alterations()
		event_component.start()

func check_for_event_alterations():
	pass
	
func set_event_component(node):
	event_component = node
	node.event_list = event_list
	event_component.look_dir_changed.connect(look)
	event_component.Battle.connect(start_battle)
	event_component.event_list_over.connect(event_list_over)
	event_component.event_over.connect(event_over)

func event_over():
	pass

func event_list_over():
	pass
	
func set_battle_component(node):
	battle_component = node

func start_battle():
	battle_component.battle(my_pokemons.duplicate(),map)
	
func look(dir):
	if TrainerSkin != null:
		TrainerSkin.look(dir)

func set_losing_component(node):
	Losing_component = node
	Losing_component.check_battle.connect(return_battling)
	Losing_component.battle_over.connect(lose)
	Losing_component._connect()
	
func return_battling():
	Losing_component.get_losing(event_component.battling)
	
func lose(ev_list:EventList = losing_event_list):
	event_list = ev_list
	event_component.event_list = event_list
	event_component.reset()
	after_lose()
	
func after_lose():
	pass
	
func set_start_lose_component(node):
	start_lose_component = node
	cannot_battle.connect(start_lose_component.start_process)
