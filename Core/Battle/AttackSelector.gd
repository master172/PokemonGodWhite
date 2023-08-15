extends Sprite2D


enum STATES {
	EMPTY,
	RADIAL
}

var state = STATES.EMPTY

var current_selected:int = 0
var max_selectable:int = 4

signal attack_chosen(attack:int)
signal cancel

var pokemon:game_pokemon
func change_selected():
	frame = current_selected + 1

func _ready():
	pokemon = get_parent().pokemon
	_set_radial()
	change_selected()
	
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
			emit_signal("attack_chosen",current_selected)
			state = STATES.EMPTY
			_set_radial()
		elif event.is_action_pressed("No"):
			state = STATES.EMPTY
			_set_radial()
			emit_signal("cancel")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _set_radial():
	if state == STATES.RADIAL:
		visible = true
		for i in range(4) :
			get_child(i).visible = true
			get_child(i).text = pokemon.get_learned_attack_name(i)
	else:
		visible = false


func start_radial():
	state = STATES.RADIAL
