extends Control

@onready var code_label: Label = $VBoxContainer/Panel/CodeLabel
var code:String = ""

func set_code(code_:String):
	code = code_
	code_label.text = "Room Code: "+code
