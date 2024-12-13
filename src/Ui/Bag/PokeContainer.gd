extends VBoxContainer


func _all_display():
	for i in get_children():
		i._display()
