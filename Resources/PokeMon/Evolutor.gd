extends Resource
class_name  Evolutor

@export var Triggers :Array[trigger] = []

@export var TriggersActive:Array[trigger] = []

func check_evolution(pokemon:game_pokemon):
	TriggersActive = []
	for i in Triggers:
		var to_evolve :bool = i.check_evolution(pokemon)
		var already_can_evolve = i.can_evolve
		if to_evolve == true and already_can_evolve == false:
			TriggersActive.append(i)

func set_stone_availaible(val:bool,type:EvolutionStone):
	TriggersActive = []
	for i in Triggers:
		i.set_stone_availabile(val,type)
		
func set_trade_availaible(val:bool,):
	TriggersActive = []
	for i in Triggers:
		i.set_trade_availabile(val)

func get_evolution_stone():
	var return_array:Array[EvolutionStone]
	for i in Triggers:
		if i.evolution_type == 1:
			return_array.append(i.evolving_stone)
	return return_array
	
func get_active_triggers():
	return TriggersActive

func get_active_triggers_size():
	return TriggersActive.size()

func get_active_trigger(num:int):
	if TriggersActive.size() >= num+1:
		return TriggersActive[num]
