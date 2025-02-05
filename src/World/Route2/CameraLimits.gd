extends AnimationPlayer


func _on_area_2d_body_entered(body: Node2D) -> void:
	play("Area1")


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	play("Area2")
