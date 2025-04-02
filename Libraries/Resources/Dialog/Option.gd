extends Resource

class_name Option

@export var text:String = ""
@export var functions:Array[Function]
@export var next:int

func format_text(format):
	text = text.format(format)
