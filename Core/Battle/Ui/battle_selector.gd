extends Control

@export var DeselectedColor:Color = Color.WHITE
@export var SelectedColor:Color = Color.GREEN

var options_selectable:int = 4
var selected_option:int = 0

var options:Array = []

@onready var main = $Main
@onready var left = $Main/Left
@onready var Left_label = $Main/Left/Label
@onready var right = $Main/Right
@onready var Right_label = $Main/Right/Label
@onready var Main_label = $Main/Label

enum STATES {
	EMPTY,
	RADIAL
}

var state = STATES.EMPTY

signal attack_chosen(attack:int)
signal cancel
signal displayed

var pokemon:game_pokemon

func _ready():
	pokemon = get_parent().get_parent().pokemon
	_set_radial()
	for i in range(4) :
		options.append(pokemon.get_learned_attack_name(i))
	set_active_option()
	
func set_active_option():
	Main_label.text = options[selected_option]
	main.self_modulate = SelectedColor
	var right_num = (selected_option +options_selectable - 1) % options_selectable
	var left_num = (selected_option + 1) % options_selectable
	Left_label.text = options[left_num]
	Right_label.text = options[right_num]
	
func _input(event):
	if state == STATES.RADIAL:
		_set_radial()
		if event.is_action_pressed("A"):
			AudioManager.input()
			selected_option  = (selected_option +options_selectable - 1) % options_selectable
			set_active_option()
			
		elif event.is_action_pressed("D"):
			AudioManager.input()
			selected_option  = (selected_option + 1) % options_selectable
			set_active_option()
			
		elif event.is_action_pressed("Yes"):
			AudioManager.select()
			emit_signal("attack_chosen",selected_option)
			state = STATES.EMPTY
			_set_radial()
			
		elif event.is_action_pressed("No"):
			AudioManager.cancel()
			state = STATES.EMPTY
			_set_radial()
			emit_signal("cancel")
		
func _set_radial():
	if state == STATES.RADIAL:
		visible = true
		emit_signal("displayed")
		for i in range(4) :
			options.append(pokemon.get_learned_attack_name(i))
			
	else:
		visible = false

func start_radial():
	state = STATES.RADIAL
