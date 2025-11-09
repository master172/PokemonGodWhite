extends Control

@export var previous_pokemon:game_pokemon
@export var current_pokemon:Pokemon

@onready var previous: TextureRect = $Container/Previous
@onready var current: TextureRect = $Container/Current
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var congratulation_dialog:DialogueLine = DialogueLine.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	if previous_pokemon != null and current_pokemon != null:
		previous.texture = previous_pokemon.get_front_sprite()
		current.texture = current_pokemon.get_front_sprite()
	Dialogic.connect("signal_event",finish)
	Dialogic.start('Descent')
	
func set_pokemons(a:game_pokemon,b:Pokemon):
	previous_pokemon = a
	current_pokemon = b
	Dialogic.VAR.Utils.Evolution.previous = a.Nick_name
	Dialogic.VAR.Utils.Evolution.current = b.Name


func finish(dial):
	if dial == "Start Evolving":
		animation_player.play("Evolve")
	
	elif dial == "END":
		queue_free()
		Utils.get_scene_manager().transition_exit_evolution()
		
