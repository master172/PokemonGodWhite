extends Resource
class_name ability

@export var name :String = ""
@export var description :String = ""

@export var Ability :PackedScene = null


func use():
    var abilityInstance = Ability.instantiate()
    return abilityInstance