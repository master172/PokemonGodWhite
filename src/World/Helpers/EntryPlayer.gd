extends AnimationPlayer

@export var color_rect:ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.color = Color.BLACK
	var scene_mangaer = Utils.get_scene_manager()
	if scene_mangaer != null:
		scene_mangaer.connect("data_set_finished",play_entry)
	else:
		color_rect.color = Color.TRANSPARENT
		
func play_entry():
	play("Default")
