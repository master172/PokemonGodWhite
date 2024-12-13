extends AudioStreamPlayer2D

class_name randomAudioPlayer

@export var Audios:Array[AudioStream]

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("finished",_on_finished)
	shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func shuffle():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var choice = rng.randi_range(0,Audios.size() -1)
	stream = Audios[choice]
	
func _on_finished():
	shuffle()
