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
@export var learned_attacks:Array[GameAction]

@export_group("nec")
@export var exp:int = 0
@export var exp_to_next_level:int = 0
@export var exp_to_current_level:int = 0

@export_subgroup("pokemon")
@export var gender:int = 0

@export_subgroup("battle")
@export var fainted:bool = false

signal Level_up
signal experience_added

func _init(pokemon:Pokemon = Pokemon.new() ,lev:int = 0,NickName:String = ""):
	Base_Pokemon = pokemon
	level = lev
	
	if NickName != "":
		Nick_name = NickName
	else:
		Nick_name = Base_Pokemon.Name
	
	set_nature()
	calculate_stats_init()
	set_exp_to_levels()
	calc_gender()
	
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
	IV_Speed = rng.randi_range(0,31)
	
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
		if nature.get_increased_stat() == stat:
			return 1.1
			
		if nature.get_decreased_stat() == stat:
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

func inital_learn_moves():
	for i in Base_Pokemon.Actions:
		if i.learned_level <= self.level and learned_attacks.size() <= 3:
			var move_to_learn = GameAction.new(i)
			learned_attacks.append(move_to_learn)

func get_learned_attack_name(num:int):
	if learned_attacks.size() >= num +1:
		return learned_attacks[num].Name()
	return ""

func initiate_attack(num:int,user:CharacterBody2D):
	if learned_attacks.size() >= num + 1:
		learned_attacks[num].start_attack(user)

func get_learned_attacks():
	return learned_attacks.size() -1

func get_learned_attack(num:int):
	return learned_attacks[num]

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
