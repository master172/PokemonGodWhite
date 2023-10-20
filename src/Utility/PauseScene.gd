extends CanvasLayer

var paused:bool = false

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = not paused
		get_tree().paused = paused
	visible = paused

func _on_continue_pressed():
	paused = not paused
	get_tree().paused = paused

func _on_exit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	pass # Replace with function body.
