extends Control

const PATH = "res://Core/Pokemon/EvolutionLines"
const EXTENSION =  "tres"

@export var previous_pokemon:game_pokemon
@export var current_pokemon:Pokemon

@onready var previous = $Previous
@onready var current = $Current

@export var congratulation_dialog:DialogueLine = DialogueLine.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if previous_pokemon != null and current_pokemon != null:
		previous.texture = previous_pokemon.get_front_sprite()
		current.texture = current_pokemon.get_front_sprite()

func set_pokemons(a:game_pokemon,b:Pokemon):
	previous_pokemon = a
	current_pokemon = b

func _on_animation_player_animation_finished(anim_name):
	congatulate()

func congatulate():
	congratulation_dialog.add_symbols_to_replace({"P1":previous_pokemon.Nick_name})
	congratulation_dialog.add_symbols_to_replace({"P2":current_pokemon.Name})
	
	DialogLayer.get_child(0)._start(congratulation_dialog)
	DialogLayer.get_child(0).connect("finished",finish)
	
func finish(dial):
	if dial == congratulation_dialog:
		
		queue_free()
		Utils.get_scene_manager().transistion_exit_evolution()
		
