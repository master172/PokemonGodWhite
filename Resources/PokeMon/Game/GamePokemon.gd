extends Resource
class_name game_pokemon

@export var Base_Pokemon:Pokemon

@export_group("general_info")
@export var Nick_name:String = ""
@export_group("stats")
@export var level:int = 0
@export_subgroup("Max values")
@export var Max_Health:int = 0
@export var Max_Attack:int = 0
@export var Max_Defense:int = 0
@export var Max_Special_Defense:int = 0
@export var Max_Special_Attack:int = 0
@export var Max_Speed:int = 0

@export_subgroup("Induvidual values")
@export var IV_Health:int = 0
@export var IV_Attack:int = 0
@export var IV_Defense:int = 0
@export var IV_Special_Defense:int = 0
@export var IV_Special_Attack:int = 0
@export var IV_Speed:int = 0

@export_subgroup("Effort values")
@export var EV_Health:int = 0
@export var EV_Attack:int = 0
@export var EV_Defense:int = 0
@export var EV_Special_Defense:int = 0
@export var EV_Special_Attack:int = 0
@export var EV_Speed:int = 0

@export_subgroup("Current values")
@export var Health : int = 0
@export var Attack : int = 0
@export var Defense : int = 0
@export var Special_Defense : int = 0
@export var Special_Attack : int = 0
@export var Speed : int = 0

@export_group("personality")
@export var nature :Nature

@export_group("misc")
@export var stats_calculated:bool = false

@export_group("attacks")
@export var move_pool :Array[MovePoolAction]
@export var learned_attacks:Array[GameAction]
@export var learnable_attacks:Array[MovePoolAction]

@export_group("nec")
@export var exp:int = 0
@export var exp_to_next_level:int = 0
@export var exp_to_current_level:int = 0

@export_subgroup("pokemon")
@export var gender:int = 0

@export_subgroup("battle")
@export var fainted:bool = false

@export_subgroup("evolution")
@export var evolutor:Evolutor

@export_subgroup("friendship")
@export var friendship:int = 0
@export var max_friendship:int = 300

signal Level_up
signal experience_added

signal learn_move(pokemon,move)
signal learn_extra_move(pokemon,move)
signal replaced_moves(pokemon,prev_move,new_move)

signal learning_process_complete

#stages
var attack_stage:int = 0
var defense_stage:int = 0
var special_attack_stage:int = 0
var special_defense_stage:int = 0
var speed_stage:int = 0
var health_stage:int = 0

func _init(pokemon:Pokemon = Pokemon.new() ,lev:int = 0,NickName:String = "",Gender:int = -1,egg_values:Array = []):
	Base_Pokemon = pokemon
	level = lev
	
	
	if NickName != "":
		Nick_name = NickName
	else:
		Nick_name = Base_Pokemon.Name
	
	
	set_movepool()
	set_nature()
	if egg_values == []:
		calculate_stats_init()
	else:
		calculate_stats_from_parents(egg_values)
	set_exp_to_levels()
	
	if Gender == -1:
		calc_gender()
	else:
		gender = Gender
	
	evolutor = Base_Pokemon.evolutor.duplicate()
	
	friendship = Base_Pokemon.default_friendship

func set_movepool():
	for i in Base_Pokemon.Actions:
		move_pool.append(MovePoolAction.new(i))
		
func calc_gender():
	var gender_rng = RandomNumberGenerator.new()
	gender = gender_rng.randi_range(0,1)

func calculate_IVs():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	IV_Health = rng.randi_range(1,31)
	rng.randomize()
	IV_Attack = rng.randi_range(1,31)
	rng.randomize()
	IV_Defense = rng.randi_range(1,31)
	rng.randomize()
	IV_Special_Defense = rng.randi_range(1,31)
	rng.randomize()
	IV_Special_Attack = rng.randi_range(1,31)
	rng.randomize()
	IV_Speed = rng.randi_range(1,31)
	
func calculate_current_max_stats():
	Max_Health = floor(0.01 * (2 * Base_Pokemon.Base_Health + IV_Health + floor(0.25 * EV_Health)) * level) + level + 10
	Max_Attack = (floor(0.01 * (2* Base_Pokemon.Base_Attack + IV_Attack + floor(0.25 * EV_Attack)) * level) + 5) * get_nature_multiplier(1)
	Max_Defense = (floor(0.01 * (2* Base_Pokemon.Base_Defense + IV_Defense + floor(0.25 * EV_Defense)) * level) + 5) * get_nature_multiplier(2)
	Max_Special_Attack = (floor(0.01 * (2* Base_Pokemon.Special_Base_Attack + IV_Special_Attack + floor(0.25 * EV_Special_Attack)) * level) + 5) * get_nature_multiplier(3)
	Max_Special_Defense = (floor(0.01 * (2* Base_Pokemon.Special_Base_Defense + IV_Special_Defense + floor(0.25 * EV_Special_Defense)) * level) + 5) * get_nature_multiplier(4)
	Max_Speed = (floor(0.01 * (2 * Base_Pokemon.Base_Speed + IV_Speed + floor(0.25 * EV_Speed)) * level) + 5) * get_nature_multiplier(5)

func set_to_max_stats():
	Health = Max_Health
	Attack = Max_Attack
	Defense = Max_Defense
	Special_Attack = Max_Special_Attack
	Special_Defense = Max_Special_Defense
	Speed = Max_Speed
	
func print_stats():
	print("Current")
	print(Health," ",Attack," ",Defense," ",Special_Attack," ",Special_Defense," ",Speed )
	print("Iv")
	print(IV_Health," ",IV_Attack," ",IV_Defense," ",IV_Special_Attack," ",IV_Special_Defense," ",IV_Speed)

func set_nature():
	var rng = RandomNumberGenerator.new()
	var index = rng.randi_range(0,Base_Pokemon.natures.size() -1)
	var NATURE = load(Base_Pokemon.natures[index])
	nature = NATURE
	
func get_nature_multiplier(stat:int):
	if nature != null:
		if nature.get_increased_stat() == stat and nature.get_decreased_stat() == stat:
			return 1
		elif nature.get_increased_stat() == stat:
			return 1.1
			
		elif nature.get_decreased_stat() == stat:
			return 0.9
	
	return 1
	
func calculate_stats():
	calculate_IVs()
	calculate_current_max_stats()
	set_to_max_stats()

func recalculate_stats():
	calculate_current_max_stats()
	
func set_attacks():
	inital_learn_moves()

func calculate_stats_init():
	if stats_calculated == false:
		calculate_stats()
		set_attacks()
		stats_calculated = true

func get_overworld_sprite():
	return Base_Pokemon.get_overworld_sprite()

func get_icon():
	return Base_Pokemon.get_icon_sprite()

func get_front_sprite():
	return Base_Pokemon.get_front_sprite()

func inital_learn_moves():
	for i in move_pool:
		if i.action.learned_level <= self.level:
			if learned_attacks.size() <= 3:
				var move_to_learn = GameAction.new(i.action)
				learned_attacks.append(move_to_learn)
				i.learned = true
				
func learn_moves():
	learnable_attacks = []
	for i in move_pool:
		if Global.auto_moves == true:
			if i.action.learned_level <= self.level and i.learned == false and i.skipped == false:
				var move_to_learn = GameAction.new(i.action)
				if learned_attacks.size() <= 3:
					learned_attacks.append(move_to_learn)
					i.learned = true
					PokemonManager.movesLearned.append(MoveToLearn.new(self,i))
					emit_signal("learn_move",self,i)
				else:
					
					PokemonManager.MovesToLearn.append(MoveToLearn.new(self,i))
					emit_signal("learn_extra_move",self,i)
			emit_signal("learning_process_complete")
		else:
			var to_learn_move:bool = true
			if i.action.learned_level <= self.level and i.learned == false:
				for j in learned_attacks:
						if j.Name().to_lower() == i.action.name.to_lower():
							to_learn_move = false
				
				if to_learn_move == true:
					learnable_attacks.append(i)

func learn_move_manual(move:int):
	var move_to_learn = GameAction.new(learnable_attacks[move].action)
	learned_attacks.append(move_to_learn)
	learnable_attacks.remove_at(move)
	

func forget_move_manual(move:int):
	var move_to_forget = learned_attacks[move]
	
	for i in move_pool:
		if i.action == move_to_forget.base_action:
			i.learned = false
		
	learned_attacks.remove_at(move)

	learnable_attacks.append(MovePoolAction.new(move_to_forget.base_action))
	

func replace_moves_manual(move1:int,move2:int):
	var move_to_forget = learned_attacks[move1]
	
	for i in move_pool:
		if i.action == move_to_forget.base_action:
			i.learned = false
			
	var move_to_learn = GameAction.new(learnable_attacks[move2].action)
	
	learned_attacks[move1] = move_to_learn
	
	learnable_attacks[move2] = MovePoolAction.new(move_to_forget.base_action)
	
func get_learnable_attack_name(num:int):
	if learnable_attacks.size() >= num + 1:
		return learnable_attacks[num].action.name
	return ""
	
func get_learned_attack_name(num:int):
	if learned_attacks.size() >= num +1:
		return learned_attacks[num].Name()
	return ""

func initiate_attack(num:int,user:CharacterBody2D):
	if learned_attacks.size() >= num + 1:
		learned_attacks[num].start_attack(user)

func get_learned_attacks():
	return learned_attacks.size() -1

func get_all_learned_attacks():
	return learnable_attacks
	
func get_learned_attack(num:int):
	if learned_attacks.size()-1 >= num:
		return learned_attacks[num]
	else:
		return null

func get_Type1():
	return Base_Pokemon.get_Type1()

func get_Type2():
	return Base_Pokemon.get_Type2()

func add_exp(exper):
	exp += exper
	check_level_up()
	
func check_level_up():
	if exp >= exp_to_next_level:
		level_up()
		emit_signal("Level_up")
	else:
		emit_signal("experience_added")
func level_up():
	
	level +=1
	set_exp_to_levels()
	learn_moves()
	check_evolution()
	add_friendship(5)

func set_exp_to_levels():
	exp_to_current_level = calc_exp_to_level(level-1)
	exp_to_next_level = calc_exp_to_level(level)
	calculate_current_max_stats()
	
func calc_exp_to_level(lev):
	var etl:int = 0
	if Base_Pokemon.leveleing_type == 0:
		etl = 5 * pow(lev,3)
	elif Base_Pokemon.leveleing_type == 1:
		etl = 6/5 * pow(lev,3) - 15*pow(lev,2) + 100*lev - 140
	elif Base_Pokemon.leveleing_type == 2:
		etl = pow(lev,3)
	elif Base_Pokemon.leveleing_type == 3:
		etl = 4*pow(lev,3)/5
	elif Base_Pokemon.leveleing_type == 4:
		if lev <= 50:
			etl = pow(lev,3)*(100 - lev)/50
		elif lev <= 68:
			etl = pow(lev,3)*(100 - lev)/100
		elif lev <= 98:
			etl = pow(lev,3)*1911 - 10*lev/3
		elif lev <= 100:
			etl = pow(lev,3)*(160-lev)/100
	elif Base_Pokemon.leveleing_type == 5:
		if lev <= 15:
			etl = pow(lev,3)*(((lev+1)/3)+24)/50
		elif lev <= 36:
			etl = pow(lev,3)*(lev+14)/50
		elif lev <= 100:
			etl = pow(lev,3)*((lev/2)+32)/50
	
	return etl

func give_experience_points(enemy):
	var points_to_give = calculate_experience_points()
	enemy.recive_experience_points(points_to_give)
	give_iv_yield(enemy)
	
func recive_experience_points(expr):
	add_exp(expr)
	
func calculate_experience_points():
	var trainer = 1
	var wild = 1
	var exp = ((Base_Pokemon.base_experience * level)* trainer * wild)/7
	return exp

func give_iv_yield(pokemon:game_pokemon):
	pokemon.EV_Health += Base_Pokemon.Yield_Health
	pokemon.EV_Attack += Base_Pokemon.Yield_Attack
	pokemon.EV_Defense += Base_Pokemon.Yield_Defense
	pokemon.EV_Special_Defense += Base_Pokemon.Yield_Special_Defense
	pokemon.EV_Special_Attack += Base_Pokemon.Yield_Special_Attack
	pokemon.EV_Speed += Base_Pokemon.Yield_Speed
	pokemon.recive_ev_yield()

func recive_ev_yield():
	calculate_current_max_stats()

func heal():
	fainted = false
	set_to_max_stats()

func replace_moves(index,move:MovePoolAction):
	move.learned = true
	var move_to_learn = GameAction.new(move.action)
	emit_signal("replaced_moves",self,learned_attacks[index],move_to_learn)
	learned_attacks[index] = move_to_learn
	print_debug("step 3")

func get_catch_rate():
	return Base_Pokemon.get_catch_rate()
#func move_process():

func check_evolution():
	if evolutor != null:
		evolutor.check_evolution(self)
		print("checking evolution")

func evolve_with_evolutor(num:int):
	var active_trigger = evolutor.get_active_trigger(num)
	var poke = active_trigger.get_next_pokemon()
	evolve(poke)

func get_current_evolution_pokemon(num:int):
	var active_trigger = evolutor.get_active_trigger(num)
	var poke = active_trigger.get_next_pokemon()
	return poke
	
func evolve(pokemon):
	if Nick_name == Base_Pokemon.Name:
		set_nickname(pokemon.Name)
	Base_Pokemon = pokemon
	
	set_movepool()
	learn_moves()
	recalculate_stats()
	set_to_max_stats()
	evolutor = Base_Pokemon.evolutor.duplicate()


func set_nickname(name):
	Nick_name = name

func get_current_evolution_triggers():
	return evolutor.get_active_triggers()

func calculate_stats_from_parents(egg_values:Array):
	if stats_calculated == false:
		calculate_stats_parents(egg_values)
		set_attacks()
		stats_calculated = true

func calculate_stats_parents(egg_values:Array):
	calculate_IV_from_parent(egg_values)
	calculate_current_max_stats()
	set_to_max_stats()
	
func calculate_IV_from_parent(egg_values:Array):
	var p1:game_pokemon = egg_values[1]
	var p2:game_pokemon = egg_values[2]
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	IV_Health = (p1.IV_Health + p2.IV_Health)/2 + rng.randi_range(-2,2)
	rng.randomize()
	IV_Attack = (p1.IV_Attack + p2.IV_Attack)/2 + rng.randi_range(-2,2)
	rng.randomize()
	IV_Defense = (p1.IV_Defense + p2.IV_Defense)/2 + rng.randi_range(-2,2)
	rng.randomize()
	IV_Special_Defense = (p1.IV_Special_Defense + p2.IV_Special_Defense)/2 + rng.randi_range(-2,2)
	rng.randomize()
	IV_Special_Attack = (p1.IV_Special_Attack + p2.IV_Special_Attack)/2 + rng.randi_range(-2,2)
	rng.randomize()
	IV_Speed = (p1.IV_Speed + p2.IV_Speed)/2 + rng.randi_range(-2,2)

func reset_stages():
	attack_stage = 0
	defense_stage = 0
	special_attack_stage = 0
	special_defense_stage = 0
	speed_stage = 0
	health_stage = 0

func add_friendship(value:int):
	friendship += value
	if friendship > max_friendship:
		friendship = max_friendship

func get_friendship():
	return friendship

func set_friendship(value:int):
	friendship = value
	friendship = clamp(friendship,0,max_friendship)

func remove_friendship(value:int):
	friendship -= value
	if friendship < 0:
		friendship = 0

func get_ability():
	return Base_Pokemon.Ability