extends CharacterBody2D
class_name BaseTrainer
const TRAINER_BASE_ORDER = preload("res://src/Npc/Base/trainer_base_order.tscn")
@export var TrainerResource:NewTrainer

var event_component

func _ready():
	add_nodes()
	
	
func add_nodes():
	self.add_child(TRAINER_BASE_ORDER.instantiate())

func GetTrainerResource():
	return TrainerResource

func _interact():
	if event_component != null:
		event_component.start()

func set_event_component(node):
	event_component = node
	node.event_list = TrainerResource.event_list
