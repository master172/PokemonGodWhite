extends TextureRect

var index:int = 0
var pokemon:game_pokemon

@onready var label = $Label

var active:bool = false

func _ready():
	update_seleceted()
	update()

func update():
	if pokemon != null:
		label.text = pokemon.get_learnable_attack_name(index)
		
func set_active(value:bool):
	active = value
	update_seleceted()
	
func update_seleceted():
	if active == true:
		self_modulate = Color(0,0,0)
	else:
		self_modulate = Color(1,1,1)
