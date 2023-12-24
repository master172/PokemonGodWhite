extends Sprite2D

func _ready():
	var parent = get_parent()
	if parent.has_method("GetTrainerResource"):
		var resource = parent.GetTrainerResource()
		if resource == null:
			return
		texture = resource.sprite
