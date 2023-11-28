extends Control

@onready var animation_player = $AnimationPlayer

signal done

func _ready():
	visible = false
	
func start():
	visible = true
	animation_player.play("Intro")
	
func _emit_done():
	emit_signal("done")


func _on_skip_button_down():
	animation_player.speed_scale = 4


func _on_skip_button_up():
	animation_player.speed_scale = 0.5
