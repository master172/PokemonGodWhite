extends Node2D
@onready var background = $BackGround
@onready var sprite = $Sprite
@onready var Name = $Name
@onready var level = $Level
@onready var gender = $Gender
@onready var health_bar = $HealthBar

@export var slot_no:int = 0
var pokemon:game_pokemon = null
func change_selected(value:bool):
	if value == true:
		background.frame = 1
	else:
		background.frame = 0

func _ready():
	if AllyPokemon.get_party_pokemon(slot_no) != null:
		pokemon = AllyPokemon.get_party_pokemon(slot_no)
		update_items()
	else:
		clear_items()
		
func update_items():
	sprite.texture = pokemon.get_icon()
	Name.text = pokemon.Base_Pokemon.Name
	level.text = str(pokemon.level)
	health_bar.max_value = pokemon.Max_Health
	health_bar.value = pokemon.Health
	
func clear_items():
	self.visible = false
