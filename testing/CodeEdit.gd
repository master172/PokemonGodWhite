extends Control

var set:int = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	check()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func check():
	if set == 1:
		print(set)
		set += 1
		check()
	else:
		print(set)
