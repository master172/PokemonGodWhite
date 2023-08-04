extends Node2D
@onready var random_audio_player = $randomAudioPlayer


func _on_button_pressed():
	random_audio_player.play()
