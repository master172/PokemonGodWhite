extends Resource

class_name Dialog

enum dialog_Type {
	Normal,
	Question,
	Conditional,
}


@export_group("dialog_information")
@export var Dialog_type:dialog_Type = 0 
@export var text :String = ""
@export var next:int

@export_group("actors")
@export var Speakers :Array[NodePath] =[]
@export var Listners :Array[NodePath] =[]

@export_group("methods")
@export var functions :Array[Function] = []
@export var Options:Array[Option]

func get_dialog_type():
	return Dialog_type

func format_text(format):
	text = text.format(format)
	if Options.size() >= 1:
		for i in Options:
			i.format_text(format)
