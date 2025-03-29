extends GameAbility

var opponents= []
@export var stages:int = -2


func setup():
	opponents = Holder.opposing_pokemons
	for i in opponents:
		print("Intimadting "+i.pokemon.Nick_name)
		var Target :game_pokemon = i.pokemon
		Target.attack_stage = clamp(Target.attack_stage + stages,-6,6)
		print_debug("target attack stage = ",Target.attack_stage)
		i.animate_modulation_change()
