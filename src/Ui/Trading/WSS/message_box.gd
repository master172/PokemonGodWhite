extends Control

@onready var title: Label = $Panel/VBoxContainer/Title
@onready var message: Label = $Panel/VBoxContainer/Message

func display():
	show()

func _ready():
	hide()
	
func set_title(inp:String):
	title.text = inp

func set_message(inp:String):
	message.text = inp

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Yes") or event.is_action_pressed("No"):
		if visible == true:
			hide()
