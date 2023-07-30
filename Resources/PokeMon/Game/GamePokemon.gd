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

func _init(pokemon:Pokemon = Pokemon.new() ,lev:int = 0,NickName:String = ""):
	Base_Pokemon = pokemon
	level = lev
	
	if NickName != "":
		Nick_name = NickName
	else:
		Nick_name = Base_Pokemon.Name
	
	set_nature()
	calculate_stats_init()
	

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
				
