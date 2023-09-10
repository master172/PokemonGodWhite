extends Resource
class_name MoveToLearn

@export var pokemon:game_pokemon
@export var move:MovePoolAction

func _init(poke:game_pokemon = game_pokemon.new(),Move:MovePoolAction = MovePoolAction.new()):
	pokemon = poke
	move = Move
