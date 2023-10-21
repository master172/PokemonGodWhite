extends TextureRect

const normal_color = Color(1, 1, 1)
const active_color = Color(0,0,0)
var active:bool = false

var pokemon:game_pokemon

@onready var gender = $Gender
@onready var Name = $Name
@onready var icon = $Icon
@onready var level = $Level

func _ready():
	if pokemon != null:
		update()
	
func change_selected(a:bool):
	active = a
	change_sprite()

func change_sprite():
	if active == true:
		self_modulate = active_color
		return
	self_modulate = normal_color

func get_pokename():
	return pokemon.Nick_name

func set_pokemon(given_pokemon):
	pokemon = given_pokemon
	

func update():
	Name.text = pokemon.Nick_name
	gender.frame = pokemon.gender
	level.text = "Level: "+str(pokemon.level)
	icon.texture = pokemon.get_icon()
