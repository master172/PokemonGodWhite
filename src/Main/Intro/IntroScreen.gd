extends Control

@onready var animation_player = $AnimationPlayer

signal done

func start():
	animation_player.play("Intro")
	
func _emit_done():
	emit_signal("done")
