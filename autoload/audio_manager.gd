extends Node

@onready var ambient_exploration = $AmbientExploration
@onready var battle = $Battle

@onready var input_audio = $Ui/Input
@onready var select_audio = $Ui/Select
@onready var cancel_audio = $Ui/Cancel

func switch_to_battle():
	battle.seek(0)
	battle.play()

	ambient_exploration.seek(0)
	ambient_exploration.stop()

func switch_to_exploration():
	battle.stop()
	battle.seek(0)
	ambient_exploration.seek(0)
	ambient_exploration.play()
func input():
	input_audio.play()

func select():
	select_audio.play()

func cancel():
	cancel_audio.play()

func _on_audio_stream_player_finished():
	ambient_exploration.play()


func _on_battle_finished():
	battle.play()
