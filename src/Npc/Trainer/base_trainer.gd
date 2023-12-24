extends CharacterBody2D
class_name BaseTrainer
const TRAINER_BASE_ORDER = preload("res://src/Npc/Base/trainer_base_order.tscn")

@export var TrainerResource:NewTrainer
@export var Looking_direction:Vector2 = Vector2(0,1)

var event_component
var TrainerSkin
var battle_component

var my_pokemons:Array[game_pokemon]

@export var Pokemons:Array[Pokemon]
@export var levels:Array[int]
@export var map:int = 0

func _ready():
	add_nodes()
	look(Looking_direction)
	add_pokemon()

func add_pokemon():
	for i in range(Pokemons.size()):
		my_pokemons.append(game_pokemon.new(Pokemons[i],levels[i]))
		
func add_nodes():
	self.add_child(TRAINER_BASE_ORDER.instantiate())

func GetTrainerResource():
	return TrainerResource

func _interact():
	if event_component != null:
		event_component.start()

func set_event_component(node):
	event_component = node
	node.event_list = TrainerResource.event_list
	event_component.look_dir_changed.connect(look)
	event_component.Battle.connect(start_battle)
	
func set_battle_component(node):
	battle_component = node

func start_battle():
	battle_component.battle(my_pokemons.duplicate(),map)
	
func look(dir):
	if TrainerSkin != null:
		TrainerSkin.look(dir)
