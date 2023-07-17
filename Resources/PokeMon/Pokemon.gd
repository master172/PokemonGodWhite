extends Resource

class_name Pokemon

@export_group("general")
@export var pokeInfo : PokeInfo
@export var statSheet : StatSheet


func get_overworld_sprite():
	return pokeInfo.get_overworld_sprite()
