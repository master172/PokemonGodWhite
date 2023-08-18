extends Node

@export var won_dialog:DialogueLine
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_won_dialog(name):
	print(name)
	won_dialog.add_symbols_to_replace({"Pokemon":name})
	DialogLayer.get_child(0)._start(won_dialog)
