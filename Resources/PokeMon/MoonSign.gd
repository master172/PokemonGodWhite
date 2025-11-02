extends Resource
class_name MoonSign

enum Signs {
	NEW_MOON,
	WAXING_CRESCENT,
	FIRST_QUARTER_MOON,
	WAXING_GIBBOUS,
	FULL_MOON,
	WANING_GIBBOUS,
	LAST_QUARTER_MOON,
	WANING_CRESCENT,
}

@export var MoonSignType:Signs

var int_to_sign_mapping:Dictionary = {
	0:Signs.NEW_MOON,
	1:Signs.WAXING_CRESCENT,
	2:Signs.FIRST_QUARTER_MOON,
	3:Signs.WAXING_GIBBOUS,
	4:Signs.FULL_MOON,
	5:Signs.WANING_GIBBOUS,
	6:Signs.LAST_QUARTER_MOON,
	7:Signs.WANING_CRESCENT,
}
var moon_sign_mappings:Dictionary = {
	Signs.NEW_MOON:"Despair",
	Signs.WAXING_CRESCENT:"Greed",
	Signs.FIRST_QUARTER_MOON:"Wrath",
	Signs.WAXING_GIBBOUS:"Envy",
	Signs.FULL_MOON:"Gluttony",
	Signs.WANING_GIBBOUS:"Sloth",
	Signs.LAST_QUARTER_MOON:"Lust",
	Signs.WANING_CRESCENT:"Pride",
}

func _init(type:int=-1):
	if type == -1:
		MoonSignType = PokemonManager.get_current_moon_phase()
	else:
		MoonSignType = int_to_sign_mapping[type]
