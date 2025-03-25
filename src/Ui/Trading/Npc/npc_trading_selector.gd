extends Control

@onready var container: VBoxContainer = $VBoxContainer

enum states {
	INACTIVE,
	ACTIVE,
}

var current_state = states.INACTIVE
signal cancel
signal select(num:int)

var max_selectable:int = 6
var current_selected:int = 0

func _ready() -> void:
	visible = false
	
func update():
	for i in container.get_children():
		i.update()

func _input(event: InputEvent) -> void:
	if current_state == states.ACTIVE:
		if event.is_action_pressed("S"):
			AudioManager.input()
			container.get_child(current_selected).set_active(false)
			current_selected = (current_selected + 1) % max_selectable
			container.get_child(current_selected).set_active(true)
		elif event.is_action_pressed("W"):
			AudioManager.input()
			container.get_child(current_selected).set_active(false)
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			container.get_child(current_selected).set_active(true)
		elif event.is_action_pressed("Yes"):
			if AllyPokemon.get_Party_pokemon_size() > current_selected and current_selected >= 0:
				select.emit(current_selected)
				print(AllyPokemon.get_party_pokemon(current_selected).Nick_name)
				AudioManager.select()
			else:
				AudioManager.cancel()
		elif event.is_action_pressed("No"):
			AudioManager.cancel()
			stop()
			cancel.emit()

func start():
	visible = true
	current_state = states.ACTIVE
	container.get_child(current_selected).set_active(true)
	update()

func stop():
	visible = false
	current_state = states.INACTIVE
	container.get_child(current_selected).set_active(false)
