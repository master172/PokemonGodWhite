extends Node2D
@onready var background = $BackGround
@onready var sprite = $Sprite
@onready var Name = $Name
@onready var level = $Level
@onready var gender = $Gender
@onready var health_bar = $HealthBar
@onready var current_health = $CurrentHealth
@onready var max_health = $MaxHealth


@export var slot_no:int = 0
var pokemon:game_pokemon = null

func change_selected(value:bool):
	if value == true:
		background.self_modulate = Color(1, 1, 1, 0.451)
	else:
		background.self_modulate = Color(0.039, 0.039, 0.039, 0.451)

func _ready():
	change_selected(false)
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
	sprite.texture = pokemon.get_icon()
	Name.text = pokemon.Nick_name
	level.text = str(pokemon.level)
	health_bar.max_value = pokemon.Max_Health
	health_bar.value = pokemon.Health
	gender.frame = pokemon.gender
	current_health.text = str(pokemon.Health)
	max_health.text = str(pokemon.Max_Health)
	
func clear_items():
	self.visible = false
