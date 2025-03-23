extends Control

func _ready():
	visible = false


func _physics_process(delta):
	if Input.is_action_just_pressed("debug"):
		visible = not visible
