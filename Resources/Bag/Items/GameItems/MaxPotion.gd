extends Item
class_name max_potion

func _start(pokemon:game_pokemon = game_pokemon.new()):
    if pokemon.fainted == false:
        pokemon.Health = pokemon.Max_Health
        return 1
    return 0

func use(pokenum:int,user:BaseItem):
    var action = _start(AllyPokemon.get_party_pokemon(pokenum))
    if action == 1:
        user.set_count(-1)
