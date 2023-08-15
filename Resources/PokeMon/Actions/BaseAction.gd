extends Resource

class_name BaseAction

@export var name = ""
@export var learned_level :int = 1
@export var action:PackedScene = null

enum attacks {
	RANGE,
	MELLE
}


@export var range :attacks
