extends Resource

class_name BaseAction

@export var name = ""
@export var learned_level :int = 1
@export var action:PackedScene = null

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


@export var range :attacks
