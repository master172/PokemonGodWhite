extends Resource

class_name StatSheet

@export var level:int = 0
@export_group("Base")
@export var Base_Health :int
@export var Base_Attack :int
@export var Base_Defense :int
@export var Special_Base_Attack :int
@export var Special_Base_Defense :int
@export var Base_Speed :int

var Max_Health:int = 0
var Max_Attack:int = 0
var Max_Defense:int = 0
var Max_Special_Defense:int = 0
var Max_Special_Attack:int = 0
var Max_Speed:int = 0

var IV_Health:int = 0
var IV_Attack:int = 0
var IV_Defense:int = 0
var IV_Special_Defense:int = 0
var IV_Special_Attack:int = 0
var IV_Speed:int = 0

var EV_Health:int = 0
var EV_Attack:int = 0
var EV_Defense:int = 0
var EV_Special_Defense:int = 0
var EV_Special_Attack:int = 0
var EV_Speed:int = 0

var Health : int = 0
var Attack : int = 0
var Defense : int = 0
var Special_Defense : int = 0
var Special_Attack : int = 0
var Speed : int = 0

var Iv_dict :Dictionary= {
	"IV_Health":IV_Health,
	"IV_Attack":IV_Attack,
	"IV_Defense":IV_Defense,
	"IV_Special_Defnse":IV_Special_Defense,
	"IV_Special_Attack":IV_Special_Attack,
	"IV_Speed":IV_Speed,
}

var Ev_dict :Dictionary = {
	"EV_Health":EV_Health,
	"EV_Attack":EV_Attack,
	"EV_Defense":EV_Defense,
	"EV_Special_Defnse":EV_Special_Defense,
	"EV_Special_Attack":EV_Special_Attack,
	"EV_Speed":EV_Speed,
}

@export var nature :Nature

func add_EVs(Iv:String,to_add:int):
	Iv_dict[Iv] += to_add

func set_Ivs():
	Iv_dict = {
		"IV_Health":IV_Health,
		"IV_Attack":IV_Attack,
		"IV_Defense":IV_Defense,
		"IV_Special_Defnse":IV_Special_Defense,
		"IV_Special_Attack":IV_Special_Attack,
		"IV_Speed":IV_Speed,
	}
	
	Ev_dict = {
		"EV_Health":EV_Health,
		"EV_Attack":EV_Attack,
		"EV_Defense":EV_Defense,
		"EV_Special_Defnse":EV_Special_Defense,
		"EV_Special_Attack":EV_Special_Attack,
		"EV_Speed":EV_Speed,
	}
	
func calculate_IVs():
	var rng = RandomNumberGenerator.new()
	for i in Iv_dict.values():
		rng.randomize()
		var my_random_number = rng.randi_range(0,31)
		if i == 0:
			i = my_random_number

func calculate_current_max_stats():
	Max_Health = floor(0.01 * (2 * Base_Health + IV_Health + floor(0.25 * EV_Health)) * level) + level + 10
	Max_Attack = (floor(0.01 * (2*Base_Attack + IV_Attack + floor(0.25 * EV_Attack)) * level) + 5) * get_nature_multiplier(1)
	Max_Defense = (floor(0.01 * (2*Base_Defense + IV_Defense + floor(0.25 * EV_Defense)) * level) + 5) * get_nature_multiplier(2)
	Max_Special_Attack = (floor(0.01 * (2*Special_Base_Attack + IV_Special_Attack + floor(0.25 * EV_Special_Attack)) * level) + 5) * get_nature_multiplier(3)
	Max_Special_Defense = (floor(0.01 * (2*Special_Base_Defense + IV_Special_Defense + floor(0.25 * EV_Special_Defense)) * level) + 5) * get_nature_multiplier(4)
	Max_Speed = (floor(0.01 * (2*Base_Speed + IV_Speed + floor(0.25 * EV_Speed)) * level) + 5) * get_nature_multiplier(5)

func set_to_max_stats():
	Health = Max_Health
	Attack = Max_Attack
	Defense = Max_Defense
	Special_Attack = Max_Special_Attack
	Special_Defense = Max_Special_Defense
	Speed = Max_Speed
	
	print(Health)
	print(Attack)
	print(Defense)
	print(Special_Attack)
	print(Special_Defense)
	print(Speed)
	
func get_nature_multiplier(stat:int):
	if nature != null:
		if nature.get_increased_stat() == stat:
			return 1.1
		if nature.get_decreased_stat() == stat:
			return 0.9
	
	return 1
	
func calculate_stats():
	set_Ivs()
	calculate_IVs()
	calculate_current_max_stats()
	set_to_max_stats()
