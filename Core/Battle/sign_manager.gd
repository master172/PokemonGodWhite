extends Node

@export var owning_pokemon:BattlePokemon
@onready var heal_timer: Timer = $HealTimer

var sign_type:int = 0:
	set(value):
		sign_type = value
		init_type()
		
var pokemon:game_pokemon = null:
	set(value):
		pokemon = value
		sign_type = pokemon.moon_sign.MoonSignType

func init_type():
	if pokemon == null:
		return
	if sign_type == 0:
		pokemon.Attack = pokemon.Attack + int(pokemon.Attack*0.1)
		pokemon.Defense = pokemon.Defense + int(pokemon.Defense*0.1)
		pokemon.Special_Attack = pokemon.Special_Attack + int(pokemon.Special_Attack*0.1)
		pokemon.Special_Defense = pokemon.Special_Defense + int(pokemon.Special_Defense*0.1)
		pokemon.Speed = pokemon.Speed + int(pokemon.Speed*0.1)
		owning_pokemon.RegenRate*=1.1
		owning_pokemon.pokemon.crit_multiplier=1.2
	elif sign_type == 1:
		if not owning_pokemon.opposing_pokemons[0].pokemon.level > owning_pokemon.pokemon.level:
			return
		pokemon.Attack = pokemon.Attack + int(pokemon.Attack*0.1)
		pokemon.Defense = pokemon.Defense + int(pokemon.Defense*0.1)
		pokemon.Special_Attack = pokemon.Special_Attack + int(pokemon.Special_Attack*0.1)
		pokemon.Special_Defense = pokemon.Special_Defense + int(pokemon.Special_Defense*0.1)
		pokemon.Speed = pokemon.Speed + int(pokemon.Speed*0.1)

	elif sign_type == 2:
		pokemon.exp_multiplier = 1.2
	elif sign_type == 3:
		pokemon.Attack = pokemon.Attack + int(pokemon.Attack*0.2)
		pokemon.Special_Attack = pokemon.Special_Attack + int(pokemon.Special_Attack*0.2)
	elif sign_type == 4:
		pokemon.crit_multiplier = 1.1
		pokemon.Speed = pokemon.Speed + int(pokemon.Speed*0.1)
	elif sign_type == 5:
		pokemon.Attack = pokemon.Attack + int(pokemon.Attack*0.2)
		pokemon.crit_multiplier = 1.1
	elif sign_type == 6:
		pokemon.Defense = pokemon.Defense + int(pokemon.Defense*0.1)
		pokemon.Special_Defense = pokemon.Special_Defense + int(pokemon.Special_Defense*0.1)
		heal_timer.start()
	elif sign_type == 7:
		heal_timer.start()
		owning_pokemon.RegenRate*=1.1
		
func return_back():
	if pokemon == null:
		return
	if sign_type in [0,1,3,4,5,6]:
		pokemon.reset_stats()
	elif sign_type == 2:
		pokemon.exp_multiplier = 1
	elif sign_type == 4:
		pokemon.crit_multiplier = 1


func _on_timer_timeout() -> void:
	pokemon.heal_by_percent(0.05)
