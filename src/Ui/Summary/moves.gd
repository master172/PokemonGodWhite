extends TextureRect

@onready var move_1 = $Move1
@onready var move_2 = $Move2
@onready var move_3 = $Move3
@onready var move_4 = $Move4

@onready var moves :Array = [move_1,move_2,move_3,move_4]

func _display(pokemon:game_pokemon):
	for i in range(4):
		moves[i].text = pokemon.get_learned_attack_name(i)

