extends Control

@export var showing_pokemon:game_pokemon

@onready var info = $info


# Called when the node enters the scene tree for the first time.
func _show_info():
	info._display(showing_pokemon)

func set_pokemon(poke:game_pokemon):
	showing_pokemon = poke
	_show_info()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	pass
