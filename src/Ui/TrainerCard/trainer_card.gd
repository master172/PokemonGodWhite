extends Control

@onready var uid = $TrainerStripe/Uid
@onready var Name = $Panel/Name

@onready var one = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer/One
@onready var four = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer/Four
@onready var two = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer2/Two
@onready var five = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer2/Five
@onready var three = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer3/Three
@onready var six = $MainOverlay/HBoxContainer/HBoxContainer/VBoxContainer3/Six

@onready var sprites :Array = [one,two,three,four,five,six]
# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func update():
	if Utils.get_player() != null:
		uid.text = Utils.get_player().player_uid
	for i in range(6):
		sprites[i].texture = AllyPokemon.get_party_pokemon(i).get_front_sprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
