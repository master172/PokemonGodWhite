extends Resource

class_name Pokemon

@export_group("general")
enum TYPES {
	Normal,
	Fire,
	Grass,
	Water,
	Rock,
	Flying,
	Electric,
	Poison,
	Steel,
	Ghost,
	Dark,
	Fairy,
	Bug,
	Ice,
	Dragon,
	Fighting,
	Ground,
	Psychic
}

@export var Name:String = ""
@export var Id :int = 0

@export var Types:Array[TYPES]

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

func get_overworld_sprite():
	return Overworld

func get_icon_sprite():
	return Icon


