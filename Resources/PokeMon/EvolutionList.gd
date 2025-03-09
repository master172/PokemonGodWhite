extends Resource
class_name Evolution_sequence

@export var EvolutionLine:Array[Pokemon] = []

func get_base_pokemon():
	return EvolutionLine[0]
