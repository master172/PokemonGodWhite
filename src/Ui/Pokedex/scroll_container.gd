extends ScrollContainer

const MOVE_CONTAINER = preload("res://src/Ui/Pokedex/move_container.tscn")
var max_scroll:int = 0
@onready var v_box_container: VBoxContainer = $VBoxContainer

func set_data(pokemon:Pokemon):
	for i in pokemon.Actions:
		var A = MOVE_CONTAINER.instantiate()
		v_box_container.add_child(A)
		A.set_data(i)
		max_scroll += 1
	for i in pokemon.TmActions:
		var A = MOVE_CONTAINER.instantiate()
		v_box_container.add_child(A)
		A.set_data(i)
		max_scroll += 1
	for i in pokemon.EggActions:
		var A = MOVE_CONTAINER.instantiate()
		v_box_container.add_child(A)
		A.set_data(i)
		max_scroll += 1
		
func _input(event: InputEvent) -> void:
	if visible == true:
		if event.is_action_pressed("S"):
			scroll_vertical  = (scroll_vertical + 36) %36*max_scroll
		elif event.is_action_pressed("W"):
			scroll_vertical  = (scroll_vertical +35*max_scroll) %36*max_scroll
