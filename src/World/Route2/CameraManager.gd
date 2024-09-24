extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	play("area1")

func _on_area_2d_2_body_entered(body):
	play("area2")

func _on_area_2d_3_body_entered(body):
	play("area3")
