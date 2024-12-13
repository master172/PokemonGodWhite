extends VBoxContainer


# Called when the node enters the scene tree for the first time.

func _ready():
	_updateItems()
	
func _updateItems():
	for i in get_children():
		i.text = i.name
