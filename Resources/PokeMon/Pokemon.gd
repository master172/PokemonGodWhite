extends Resource

class_name Pokemon

@export_group("general")
@export var pokeInfo : PokeInfo
@export var statSheet : StatSheet


func get_overworld_sprite():
	return pokeInfo.get_overworld_sprite()

func get_icon():
	return pokeInfo.get_icon_sprite()

func calculate_stats():
	statSheet.calculate_stats()
