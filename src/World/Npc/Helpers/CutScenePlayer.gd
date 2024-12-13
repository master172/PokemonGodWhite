extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_aiden_finished():
	get_parent().anim_state.travel("Walk")
	play("Lose")


func finished():
	await get_tree().create_timer(0.1).timeout
	get_parent().queue_free()
