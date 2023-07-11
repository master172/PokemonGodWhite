extends Resource

class_name Dialog

enum dialog_Type {
	Normal,
	Question,
	Set_Variable,
	Get_Variable,
	Create_Variable
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


@export_group("variables")

@export_subgroup("set")
@export var set_variables:SetVariable
@export var StNext:int = 0

@export_subgroup("get")
@export var get_variables:Dictionary = {}
@export var GtNext:int = 0

func get_dialog_type():
	return Dialog_type

func format_text(format):
	text = text.format(format)
	if Options.size() >= 1:
		for i in Options:
			i.format_text(format)
