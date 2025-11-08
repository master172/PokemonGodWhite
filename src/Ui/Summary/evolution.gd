extends ColorRect

const Trigger = preload("res://src/Ui/Summary/trigger.tscn")

@onready var v_box_container = $ScrollContainer/VBoxContainer
@onready var scroll_container = $ScrollContainer

func _display(pokemon:game_pokemon):
	for i in pokemon.get_current_evolution_triggers():
		var T = Trigger.instantiate()
		v_box_container.add_child(T)
		T.update(i)

func update_after_evolution(pokemon:game_pokemon):
	for i in v_box_container.get_children():
		i.queue_free()
	for i in pokemon.get_current_evolution_triggers():
		var T = Trigger.instantiate()
		v_box_container.add_child(T)
		T.update(i)
func get_max():
	return v_box_container.get_child_count()

func update_display(num:int,value:bool):
	if v_box_container.get_child_count() >= num +1:
		v_box_container.get_child(num).set_active(value)


func _on_visibility_changed():
	if visible == false:
		for i in v_box_container.get_children():
			i.queue_free()

func scroll_full_up():
	scroll_container.scroll_vertical = 0

func scroll_down():
	scroll_container.scroll_vertical += 280

func scroll_up():
	scroll_container.scroll_vertical -= 280
