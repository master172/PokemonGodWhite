extends Control

@onready var poke_sprite = $VBoxContainer/PokeData/PokeSprite

@onready var one = $"VBoxContainer/PokeData/VBoxContainer/Button"
@onready var two = $"VBoxContainer/PokeData/VBoxContainer/Button2"
@onready var three = $"VBoxContainer/PokeData/VBoxContainer/Button3"
@onready var four = $"VBoxContainer/PokeData/VBoxContainer/Button4"
@onready var five = $"VBoxContainer/PokeData/VBoxContainer/Button5"
@onready var six = $"VBoxContainer/PokeData/VBoxContainer/Button6"

@onready var move_1 = $VBoxContainer/PokeData/Moves/Move1
@onready var move_2 = $VBoxContainer/PokeData/Moves/Move2
@onready var move_3 = $VBoxContainer/PokeData/Moves/Move3
@onready var move_4 = $VBoxContainer/PokeData/Moves/Move4

@onready var level_up = $VBoxContainer/Actions/Panel/LevelUp

@onready var buttons = [one,two,three,four,five,six]
@onready var moves = [move_1,move_2,move_3,move_4]

@onready var level = $VBoxContainer/PokeData/PokeSprite/Control/Label

var current_pokemon:game_pokemon 

func _ready():
	hide()
	_update()
	manage_connections()

		
func _update():
	if current_pokemon != null:
		poke_sprite.texture = current_pokemon.get_front_sprite()
		
		for i in range(6):
			if AllyPokemon.get_party_pokemon(i) != null:
				buttons[i].icon = AllyPokemon.get_party_pokemon(i).get_front_sprite()
		
		for i in range(4):
			moves[i].text = current_pokemon.get_learned_attack_name(i)
		
		level.text = "Levle: " + str(current_pokemon.level)

func manage_connections():
	if current_pokemon != null:
		current_pokemon.connect("learn_extra_move",learn_move)
		current_pokemon.connect("replaced_moves",learned_move)

func learned_move(pokemon:game_pokemon,prev_move:GameAction,new_move:GameAction):
	print(pokemon.Nick_name, " ", prev_move.base_action.name, " ", new_move.base_action.name)
	PokemonManager.finishing_dialog(pokemon,prev_move,new_move)
	
func learn_move(pokemon,move):
	PokemonManager.Starting_dialog(pokemon,move)
	
func change(num:int):

	if AllyPokemon.get_Party_pokemon_size() >= num+1:
		current_pokemon = AllyPokemon.get_party_pokemon(num)
		_update()

func _on_button_pressed():
	change(0)


func _on_button_2_pressed():
	change(1)


func _on_button_3_pressed():
	change(2)


func _on_button_4_pressed():
	change(3)


func _on_button_5_pressed():
	change(4)


func _on_button_6_pressed():
	change(5)


func _on_level_up_pressed():
	current_pokemon.recive_experience_points(current_pokemon.exp_to_next_level-current_pokemon.exp)

	
	_update()
	if Global.auto_evolve == true:
		Utils.get_scene_manager().check_evolution()


func _on_full_exp_pressed():
	current_pokemon.recive_experience_points((current_pokemon.exp_to_next_level-current_pokemon.exp) - 1 )
