extends Resource

class_name PokeInfo

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

func get_overworld_sprite():
	return Overworld

func get_icon_sprite():
	return Icon
