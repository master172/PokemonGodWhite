extends AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		play("Area1")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		play("Area2")
