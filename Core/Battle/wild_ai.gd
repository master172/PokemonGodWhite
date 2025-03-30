extends EnemyAI

func choose_attack(pokemon:PokeEnemy,_enemy_pokemon:BattlePokemon):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
		
	var at = rng.randi_range(0,pokemon.pokemon.get_learned_attacks_size()-1)
	return at
