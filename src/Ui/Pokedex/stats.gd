extends VBoxContainer

@onready var stat_container: VBoxContainer = $StatContainer

func set_data(pokemon:Pokemon):
	for i in stat_container.get_children():
		i.set_stat(pokemon)
