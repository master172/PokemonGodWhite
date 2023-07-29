extends Resource

class_name GameAction

@export var base_action:BaseAction = null

@export var power = 35

func _init(Base_Action:BaseAction = BaseAction.new()):
	base_action = Base_Action
