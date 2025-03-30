extends EnemyAI
class_name BasicTrainerAI
var attacklist:Array = []

func choose_attack(pokemon:PokeEnemy,enemy_pokemon:BattlePokemon):
	calc_priority_move(pokemon.pokemon,enemy_pokemon.pokemon)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var at:int
	var chance = rng.randi() % 3
	if chance == 0:
		at = attacklist[0]
	else:
		at = rng.randi_range(0,pokemon.pokemon.get_learned_attacks_size()-1)
	attacklist.clear()
	return at

func calc_priority_move(pokemon:game_pokemon,enemy_pokemon:game_pokemon):
	attacklist = pokemon.get_learned_attacks().duplicate()
	sort_moves_by_priority(enemy_pokemon)
	
func sort_moves_by_priority(pokemon:game_pokemon) -> void:
	attacklist.sort_custom(func(a:GameAction, b:GameAction): return BattleManager.get_type_modifier(a.base_action.Type,pokemon.get_Type1()) >  BattleManager.get_type_modifier(b.base_action.Type,pokemon.get_Type1()))
