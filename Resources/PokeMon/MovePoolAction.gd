extends Resource
class_name MovePoolAction

@export var action:BaseAction
@export var learned:bool = false
@export var skipped:bool = false

func _init(BaseAct:BaseAction = BaseAction.new()):
	action = BaseAct
