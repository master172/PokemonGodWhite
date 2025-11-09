extends Control

@onready var background: Panel = $Background
@onready var sprite: TextureRect = $Background/Main/Top/Sprite
@onready var Name: Label = $Background/Main/Top/VBoxContainer/Name
@onready var level: Label = $Background/Main/Top/VBoxContainer/Level
@onready var gender: TextureRect = $Background/Main/Top/Gender
@onready var health_bar: ProgressBar = $Background/Main/Panel/HealthBar
@onready var current_health: Label = $Background/Main/HBoxContainer/CurrentHealth
@onready var max_health: Label = $Background/Main/HBoxContainer/MaxHealth

@export var slot_no:int = 0
var pokemon:game_pokemon = null

func change_selected(value:bool):
	if value == true:
		background.self_modulate = Color(1, 1, 1, 0.451)
	else:
		background.self_modulate = Color(0.039, 0.039, 0.039, 0.451)

func _ready():
	if AllyPokemon.get_party_pokemon(slot_no) != null:
		pokemon = AllyPokemon.get_party_pokemon(slot_no)
		update_items()
	else:
		clear_items()

func update():
	if AllyPokemon.get_party_pokemon(slot_no) != null:
		pokemon = AllyPokemon.get_party_pokemon(slot_no)
		update_items()
	else:
		clear_items()
		
func update_items():
	sprite.texture.atlas = pokemon.get_icon()
	Name.text = pokemon.Nick_name
	level.text = str(pokemon.level)
	max_health.text = str(pokemon.Max_Health)
	current_health.text = str(pokemon.Health) + "/"
	health_bar.max_value = pokemon.Max_Health
	health_bar.value = pokemon.Health
	if pokemon.gender == 0:
		gender.texture.region = Rect2(0,0,5,8)
	elif pokemon.gender == 1:
		gender.texture.region = Rect2(5,0,5,8)
	
func clear_items():
	self.visible = false
