extends Resource

class_name Dialog

enum dialog_Type {
	Normal,
	Question
}


@export var Dialog_type:dialog_Type = 0 
@export var text :String = ""
@export var Speakers :Array[NodePath] =[]
@export var Listners :Array[NodePath] =[]
@export var functions :Array[Function] = []


@export var Options:Array[Option]
@export var next:int
