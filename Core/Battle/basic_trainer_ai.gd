extends EnemyAI
class_name BasicTrainerAI
var attacklist:Array[ScorableAction] = []

func choose_attack(pokemon:PokeEnemy,enemy_pokemon:BattlePokemon):
	set_attack_list(pokemon.pokemon,enemy_pokemon.pokemon)
	calc_priority_move(pokemon.pokemon,enemy_pokemon.pokemon)
	
	var at:int
	var chance = randi() % 2
	if chance == 0:
		var attack_to_use:ScorableAction = attacklist[0]
		at = attack_to_use.pos
	else:
		var attack_to_use:ScorableAction = attacklist[randi_range(1,attacklist.size()-1)]
		at = attack_to_use.pos
	return at

func set_attack_list(pokemon:game_pokemon,enemy_pokemon:game_pokemon):
	if attacklist == []:
		var num:int = 0
		for i in pokemon.learned_attacks:
			attacklist.append(ScorableAction.new(0,i,num))
			num += 1
		calc_type_advantage(enemy_pokemon)
		num = 0
		for i :ScorableAction in attacklist:
			print(i.action.base_action.name)
			print(i.score)
			
func calc_priority_move(pokemon:game_pokemon,enemy_pokemon:game_pokemon):
	sort_moves_by_priority(enemy_pokemon)
	
func sort_moves_by_priority(pokemon:game_pokemon) -> void:
	attacklist.sort_custom(func(a:ScorableAction, b:ScorableAction): return a.score > b.score)

func calc_type_advantage(enemy_pokemon:game_pokemon):
	for i:ScorableAction in attacklist:
		var type:int = 0 
		type += BattleManager.get_type_modifier(i.action.base_action.Type,enemy_pokemon.get_Type1())
		
		if enemy_pokemon.get_Type2() != "NONE":
			var mod = BattleManager.get_type_modifier(i.action.base_action.Type,enemy_pokemon.get_Type2())
			type = type*mod
		
		i.score += type

func reset_attacks():
	attacklist = []
