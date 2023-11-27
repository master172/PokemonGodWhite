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
