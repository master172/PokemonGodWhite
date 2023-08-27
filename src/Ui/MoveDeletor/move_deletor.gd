extends Control

var max_selected:int = 4
var current_selected = 0
@onready var attack_selector:Sprite2D = $AttackSelector

var pokemon:game_pokemon

func _input(event):
	if event.is_action_pressed("W"):
		current_selected  = (current_selected +max_selected -1) % max_selected
		change_position()
	elif event.is_action_pressed("S"):
		current_selected  = (current_selected + 1) % +max_selected
		change_position()

func change_position():
	attack_selector.position.y = 152 + current_selected * 135


func delete_move(index,move):
	pokemon.replace_moves(index,move)
