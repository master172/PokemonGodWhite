extends Item
class_name MoveMachine

@export var singal_use:bool = true
@export var action:BaseAction = null

func _start(pokemon:game_pokemon = game_pokemon.new()):
	for i in pokemon.move_pool:
		if i.action == action:
			return false
	if not pokemon.Base_Pokemon.TmActions.has(action):
		return false
	pokemon.move_pool.append(MovePoolAction.new(action))
	pokemon.learn_moves()
	return true

func use(pokenum:int,user:BaseItem):
	var succesfull :bool = _start(AllyPokemon.get_party_pokemon(pokenum))
	if singal_use and succesfull:
		user.set_count(-1)
		
