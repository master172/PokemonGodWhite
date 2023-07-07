extends Label

@onready var color_rect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_selected(option:bool):
	if option == false:
		color_rect.color = Color(0.153, 0.153, 0.153, 0.604)
	else:
		color_rect.color = Color(0.153, 0.153, 0.349, 0.604)
		
