extends AudioStreamPlayer2D

class_name LoopAudioPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished",_loop)


func _loop():
	play()
