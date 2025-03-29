extends StatusCondition
class_name PoisonEffect

func check_trigger_condition(steps:int) ->bool:
	return true

func apply_effect(pokemon:game_pokemon):
	print(pokemon.Nick_name + " should have recived poison damage")
