extends Node

@onready var ambient_exploration = $AmbientExploration
@onready var battle = $Battle
@onready var main_menu = $MainMenu
@onready var intro = $Intro

@onready var input_audio = $Ui/Input
@onready var select_audio = $Ui/Select
@onready var cancel_audio = $Ui/Cancel

func switch_to_intro():
	main_menu.stop()
	main_menu.seek(0)
	
	ambient_exploration.seek(0)
	ambient_exploration.stop()
	
	battle.stop()
	battle.seek(0)
	
	intro.seek(0)
	intro.play()
	
func switch_to_battle():
	intro.seek(0)
	intro.stop()
	
	battle.seek(0)
	battle.play()
	
	main_menu.stop()
	main_menu.seek(0)
	
	ambient_exploration.seek(0)
	ambient_exploration.stop()

func switch_to_exploration():
	intro.seek(0)
	intro.stop()
	
	battle.stop()
	battle.seek(0)
	
	main_menu.stop()
	main_menu.seek(0)
	
	ambient_exploration.seek(0)
	ambient_exploration.play()

func switch_to_mainMenu():
	intro.seek(0)
	intro.stop()
	
	ambient_exploration.seek(0)
	ambient_exploration.stop()
	
	battle.stop()
	battle.seek(0)
	
	main_menu.seek(0)
	main_menu.play()
	
	
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


func _on_main_menu_finished():
	main_menu.play()


func _on_intro_finished():
	intro.play()
