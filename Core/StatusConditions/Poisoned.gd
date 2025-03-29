extends VolatileStausCondition

func remove_condition():
	print("removing condition")
	
func _on_posioned_timer_timeout() -> void:
	deal_damage()

func deal_damage():
	if Holder != null:
		print("dealing posioned Damage")
		Holder.recive_plain_damage(1)
