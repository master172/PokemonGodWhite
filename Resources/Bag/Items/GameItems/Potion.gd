extends Item
class_name general_potions

@export var HealingHealth:int = 20

func _start(pokemon:game_pokemon = game_pokemon.new()):
	if pokemon.Health == pokemon.Max_Health:
		return 0
	elif pokemon.Health <= 0:
		return 0
	elif pokemon.Max_Health >= pokemon.Health + HealingHealth:
		pokemon.Health += HealingHealth
		return 1
	else:
		pokemon.Health = pokemon.Max_Health
		return 1

func use(pokenum:int,user:BaseItem):
	var action = _start(AllyPokemon.get_party_pokemon(pokenum))
	if action == 1:
		user.set_count(-1)
