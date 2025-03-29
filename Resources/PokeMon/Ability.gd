extends Resource
class_name ability

@export var Name :String = ""
@export var description :String = ""

@export_file("*.tscn") var Ability :String = ""


func use():
	var abilityInstance = load(Ability).instantiate()
	return abilityInstance
