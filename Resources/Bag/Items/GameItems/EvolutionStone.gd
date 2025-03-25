extends Item
class_name EvolutionStoneItem

@export var evolving_stone:EvolutionStone = null

@export var singal_use:bool = true

func _start(pokemon:game_pokemon = game_pokemon.new()):
	var stone_list = pokemon.get_stone_list()
	print(stone_list)
	if stone_list.has(evolving_stone):
		pokemon.set_stone_used(true,evolving_stone)
		pokemon.check_evolution()
		return true
	return false

func use(pokenum:int,user:BaseItem):
	var succesfull :bool = _start(AllyPokemon.get_party_pokemon(pokenum))
	if singal_use and succesfull:
		user.set_count(-1)
