extends Node

signal Buy
signal Sell

func test_function():
	print("test")

func save():
	Utils.save_data()

func Change_Dialog(param,at_what:int = 0):
	get_parent().Change_Dialog(param,at_what)

func heal():
	AllyPokemon.all_heal()

func StartMoveLearning():
	PokemonManager._startMoveLearning()

func NoToMove():
	PokemonManager.cancelMoveLearning()

func PickUpItem():
	if Utils.current_picking_up != null:
		Utils.current_picking_up.pick_up()
		Utils.current_picking_up = null

func buy():
	emit_signal("Buy")

func sell():
	emit_signal("Sell")
