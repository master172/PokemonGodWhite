extends VolatileStausCondition

var bleeding_effect_set:bool = false

func add_effect():
	bleeding_effect_set = true

func remove_condition():
	print("removing condition")

func _on_removing_timer_timeout() -> void:
	queue_free()

func _on_bleeding_timer_timeout() -> void:
	deal_damage()

func deal_damage():
	if bleeding_effect_set == true and Holder != null:
		print("dealt bleeding damage")
		Holder.pokemon.Health -= 10
