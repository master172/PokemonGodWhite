extends StaticBody2D

@export var Current_dialog:DialogueLine
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _interact():
	Utils.DialogBar._start(self.Current_dialog)
