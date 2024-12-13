extends Resource
class_name  Evolutor

@export var Triggers :Array[trigger] = []

@export var TriggersActive:Array[trigger] = []

func check_evolution(pokemon:game_pokemon):
	TriggersActive = []
	for i in Triggers:
		var to_evolve :bool = i.check_evolution(pokemon)
		if to_evolve == true:
			TriggersActive.append(i)
			break

func get_active_triggers():
	return TriggersActive

func get_active_triggers_size():
	return TriggersActive.size()

func get_active_trigger(num:int):
	if TriggersActive.size() >= num+1:
		return TriggersActive[num]
