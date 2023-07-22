extends Node2D
@onready var background = $BackGround
@onready var sprite = $Sprite
@onready var Name = $Name
@onready var level = $Level
@onready var gender = $Gender

@export var SlotNo:int
var pokemon:Pokemon = null

func change_selected(value:bool):
	if value == true:
		background.frame = 1
	else:
		background.frame = 0

func _ready():
	if AllyPokemon.get_party_pokemon(SlotNo) != null:
		pokemon = AllyPokemon.get_party_pokemon(SlotNo)
		update_items()
	else:
		clear_items()

func update_items():
	sprite.texture = pokemon.get_icon()

func clear_items():
	self.visible = false
