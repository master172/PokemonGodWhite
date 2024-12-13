extends Node2D

@export var nature:Nature

var array : Array = [1,4,"5",true,5.08]
# Called when the node enters the scene tree for the first time.

func _ready():
	print(array.size()
	)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
