extends Control

@onready var message: Label = $Panel/VBoxContainer/Message

func display(code:String)->void:
	message.text = "Room Code: "+code
