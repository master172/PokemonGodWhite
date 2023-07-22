extends Resource

class_name Nature

enum Stat {
	None,
	Attack,
	Defense,
	Special_Attack,
	Special_Defense,
	Speed
	}

@export var increased_stat :Stat
@export var decreased_stat :Stat

func get_increased_stat():
	if increased_stat == Stat.None:
		return 0
	elif increased_stat == Stat.Attack:
		return 1
	elif increased_stat == Stat.Defense:
		return 2
	elif increased_stat == Stat.Special_Attack:
		return 3
	elif increased_stat == Stat.Special_Defense:
		return 4
	elif increased_stat == Stat.Speed:
		return 5

func get_decreased_stat():
	if decreased_stat == Stat.None:
		return 0
	elif decreased_stat == Stat.Attack:
		return 1
	elif decreased_stat == Stat.Defense:
		return 2
	elif decreased_stat == Stat.Special_Attack:
		return 3
	elif decreased_stat == Stat.Special_Defense:
		return 4
	elif decreased_stat == Stat.Speed:
		return 5
