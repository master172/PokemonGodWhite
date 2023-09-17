extends StaticBody2D

@export var item:BaseItem = null
@export var pick_up_dialog:DialogueLine = null

func _interact():
	Utils.current_picking_up = self
	pick_up_dialog.add_symbols_to_replace({"Item":item.Name})
	DialogLayer.get_child(0)._start(pick_up_dialog)
	DialogLayer.get_child(0).connect("finished",finish)
	
func finish(dial):
	if dial == pick_up_dialog:
		Utils.get_player().set_physics_process(true)
	

func pick_up():
	item.pick_up()
