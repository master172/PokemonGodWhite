extends Resource

class_name Pokemon

@export_group("general")


@export var Name:String = ""
@export var Id :int = 0

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
	) var Type1:String = "Normal"

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
	"NONE"
	) var Type2:String = "NONE"

@export_enum(
	"Slow",
	"MediumSlow",
	"MediumFast",
	"Fast",
	"Erratic",
	"Fluctuating"
)var leveleing_type:int = 2

@export_group("Sprites")
@export var Front:Texture2D
@export var Back:Texture2D
@export var Icon:Texture2D
@export var Overworld:Texture2D


@export_group("statSheet")
@export_subgroup("Base")
@export var Base_Health :int
@export var Base_Attack :int
@export var Base_Defense :int
@export var Special_Base_Attack :int
@export var Special_Base_Defense :int
@export var Base_Speed :int

var natures :Array = [
	"res://Resources/PokeMon/Natures/Hardy.tres",
	"res://Resources/PokeMon/Natures/Lonely.tres"
]

@export_group("attacks")
@export var Actions:Array[BaseAction] = []

@export_group("battles")
@export var base_experience:int = 64

@export_subgroup("EV yields")
@export var Yield_Health :int = 0
@export var Yield_Attack :int = 0
@export var Yield_Defense :int = 0
@export var Yield_Special_Defense :int = 0
@export var Yield_Special_Attack :int = 0
@export var Yield_Speed :int = 0

func get_overworld_sprite():
	return Overworld

func get_icon_sprite():
	return Icon

func get_Type1():
	return Type1

func get_Type2():
	return Type2

