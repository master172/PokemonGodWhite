extends Node2D

@onready var animation_player = $AnimationPlayer


func _on_area_1_body_entered(body):
	animation_player.play("Area1")


func _on_area_2_body_entered(body):
	animation_player.play("Area2")
