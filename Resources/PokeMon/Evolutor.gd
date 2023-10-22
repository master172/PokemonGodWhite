extends Resource
class_name  Evolutor

@export var Triggers :Array[trigger] = []


func check_evolution(pokemon:game_pokemon):
	for i in Triggers:
		var to_evolve :bool = i.check_evolution(pokemon)
		if to_evolve == true:
			break
