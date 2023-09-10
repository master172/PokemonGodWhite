extends StaticBody2D

@export var Current_dialog:DialogueLine
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _interact():
	Current_dialog.add_symbols_to_replace({"NewfoundLand":"Godot"})
	DialogLayer.get_child(0)._start(self.Current_dialog)
	DialogLayer.get_child(0).connect("finished",finish)
	
func finish(dial):
	if dial == Current_dialog:
		Utils.get_player().set_physics_process(true)
