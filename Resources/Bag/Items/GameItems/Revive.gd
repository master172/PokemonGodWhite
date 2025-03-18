extends Item
class_name revive

@export_range(0.0,1.0,0.01) var health_level :float = 0.5

func _start(pokemon:game_pokemon = game_pokemon.new()):
    if pokemon.fainted == true:
        pokemon.Health = int(ceilf(pokemon.Max_Health*health_level))
        pokemon.fainted = false
        return 1
    return 0

func use(pokenum:int,user:BaseItem):
    var action = _start(AllyPokemon.get_party_pokemon(pokenum))
    if action == 1:
        user.set_count(-1)