extends Control

var max_selected:int = 4
var current_selected = 0
@onready var attack_selector:Sprite2D = $AttackSelector
@onready var sprite_2d = $PokeInfo/Sprite2D

@onready var move_1 = $Moves/Move1
@onready var move_2 = $Moves/Move2
@onready var move_3 = $Moves/Move3
@onready var move_4 = $Moves/Move4
@onready var move_5 = $Moves/Move5

@onready var Name = $PokeInfo/Name
@onready var level = $PokeInfo/Level

@onready var moves = [move_1,move_2,move_3,move_4]

var pokemon:game_pokemon

var move:MovePoolAction

enum states {INACTIVE,ACTIVE}

var state = states.INACTIVE

func _ready():
	hide()
	PokemonManager.connect("StartLearningMoves",_start)

func _start(Move:MoveToLearn):
		
	pokemon = Move.pokemon
	move = Move.move
	_startMoveLearning()
	
func _startMoveLearning():
	display()
	show()
	state = states.ACTIVE

func display():
	sprite_2d.texture = pokemon.get_front_sprite()
	for i in range(4):
		moves[i].text = pokemon.get_learned_attack_name(i)
	move_5.text = move.action.name
	Name.text = pokemon.Nick_name
	level.text = str(pokemon.level)
	
func _input(event):
	if state == states.ACTIVE:
		if event.is_action_pressed("W"):
			current_selected  = (current_selected +max_selected -1) % max_selected
			change_position()
		elif event.is_action_pressed("S"):
			current_selected  = (current_selected + 1) % +max_selected
			change_position()
		elif event.is_action_pressed("Yes") and PokemonManager.can_learn_moves == true:
			delete_move(current_selected,move)
			print_debug("step 1")
func change_position():
	attack_selector.position.y = 152 + current_selected * 135


func delete_move(index,move):
	pokemon.replace_moves(index,move)
	print_debug("step 2")
	display()
