extends Resource

class_name GameAction

@export var base_action:BaseAction = null

@export var power = 35



func _init(Base_Action:BaseAction = BaseAction.new()):
	base_action = Base_Action

func Name():
	return base_action.name

func start_attack(User:CharacterBody2D):
	var attack = base_action.action.instantiate()
	User.add_child(attack)
	attack.set_user(User)
	attack._attack()
	