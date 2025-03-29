extends Resource

class_name BaseAction

@export var name = ""
@export var learned_level :int = 1
@export_file("*.tscn") var action :String = ""

@export var staminaCost:int = 10
@export_enum(
	"Normal",
	"Fighting",
	"Flying",
	"Poison",
	"Ground",
	"Rock",
	"Bug",
	"Ghost",
	"Steel",
	"Fire",
	"Water",
	"Grass",
	"Electric",
	"Psychic",
	"Ice",
	"Dragon",
	"Dark",
	"Fairy",
	) var Type:String = "Normal"

enum attacks {
	RANGE,
	MELLE
}

@export var power := 35.0

@export var range :attacks
