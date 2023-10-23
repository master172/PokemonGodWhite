extends Control

signal pokemon_selected(pokemon:int)
enum STATES {
	EMPTY,
	RADIAL
}

var state = STATES.RADIAL

var current_selected = 0
var max_selectable = 6
@onready var radial = $Radial
@onready var pokemon_sprites = $PokemonSprites



func change_selected():
	radial.frame = current_selected + 1

func _ready():
	_start()

func _start():
	state = STATES.RADIAL
	change_selected()
	_set_radial()
	
func _input(event):
	if state == STATES.RADIAL:
		_set_radial()
		if event.is_action_pressed("A"):

			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			change_selected()
			
		elif event.is_action_pressed("D"):
			current_selected = (current_selected + 1) % max_selectable
			change_selected()
		
		elif event.is_action_pressed("Yes"):
			if AllyPokemon.get_party_pokemon(current_selected).Health > 0:
				pokemon_selected.emit(current_selected)
				visible = false
				state = STATES.EMPTY
			else:
				pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _set_radial():
	if state == STATES.RADIAL:
		visible = true
		if AllyPokemon.get_Party_pokemon_size() != null:
			for i in AllyPokemon.get_Party_pokemon_size():
				pokemon_sprites.get_child(i).visible = true
				pokemon_sprites.get_child(i).texture = AllyPokemon.get_party_pokemon(i).get_icon()
	else:
		visible = false



