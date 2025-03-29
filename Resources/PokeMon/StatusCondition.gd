extends Resource
class_name StatusCondition

@export_file("*.tscn") var status_condition:String = ""

func check_trigger_condition(steps:int) ->bool:
	return false

func apply_effect(pokemon:game_pokemon):
	return
