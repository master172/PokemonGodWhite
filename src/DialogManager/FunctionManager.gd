extends Node

signal Buy
signal Sell

signal evolve
signal Cancel

signal Switch
signal No

signal battle

signal Save

func test_function():
	print("test")

func save():
	Utils.connect("saving_done",show_after_save)
	get_parent().visible = false
	emit_signal("Save")
	

func show_after_save():
	get_parent().visible = true
	Utils.disconnect("saving_done",show_after_save)

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

func cancel():
	await get_tree().create_timer(0.1).timeout
	Utils.get_player().set_physics_process_custom(true)

func time_to_evolve():
	emit_signal("evolve")

func cancel_evolution():
	emit_signal("Cancel")

func switch():
	emit_signal("Switch")

func no():
	emit_signal("No")

func Battle():
	emit_signal("battle")
