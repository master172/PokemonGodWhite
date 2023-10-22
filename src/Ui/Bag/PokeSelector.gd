extends TextureRect

const normal = preload("res://assets/player/ash/Bag/pokeselector.png")
const active = preload("res://assets/player/ash/Bag/pokeselector1.png")

signal clicked(num:int)

@onready var container = $Container

@onready var icon = $Container/Icon
@onready var Name = $Container/Name
@onready var health_bar = $Container/HealthBar
@onready var health = $Container/health
@onready var level = $Container/Level
@onready var gender = $Container/Gender

var Active:bool = false

@export var pokemon_number:int = 0
var pokemon:game_pokemon = null

func _ready():
	update()

func update():
	pokemon = AllyPokemon.get_party_pokemon(pokemon_number)
	_display()
	
func _display():
	if pokemon != null:
		container.visible = true
		icon.texture = pokemon.get_icon()
		Name.text = pokemon.Nick_name
		health_bar.max_value = pokemon.Max_Health
		health_bar.value = pokemon.Health
		health.text = (str(pokemon.Health)+"/"+str(pokemon.Max_Health))
		gender.frame = pokemon.gender
		level.text = "lv. "+str(pokemon.level)
	else:
		container.visible = false
		
func set_active(val:bool):
	Active = val
	set_sprites()
	
func set_sprites():
	if Active == true:
		texture = active
		container.position = Vector2(64,0)
	else:
		texture = normal
		container.position = Vector2(0,0)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("clicked",pokemon_number)
