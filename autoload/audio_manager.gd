extends Node

@onready var ambient_exploration = $AmbientExploration
@onready var input_audio = $Ui/Input
@onready var select_audio = $Ui/Select
@onready var cancel_audio = $Ui/Cancel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func input():
	input_audio.play()

func select():
	select_audio.play()

func cancel():
	cancel_audio.play()

func _on_audio_stream_player_finished():
	ambient_exploration.play()
