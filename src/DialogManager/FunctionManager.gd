extends Node

func test_function():
	print("test")

func save():
	Utils.save_data()

func Change_Dialog(param,at_what:int = 0):
	get_parent().Change_Dialog(param,at_what)

func heal():
	AllyPokemon.all_heal()
