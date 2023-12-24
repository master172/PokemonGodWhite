extends CharacterBody2D
class_name BaseTrainer
const TRAINER_BASE_ORDER = preload("res://src/Npc/Base/trainer_base_order.tscn")

@export var TrainerResource:NewTrainer
@export var Looking_direction:Vector2 = Vector2(0,1)

var event_component
var TrainerSkin

func _ready():
	add_nodes()
	look(Looking_direction)
	
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
	event_component.look_dir_changed.connect(look)
	
func look(dir):
	if TrainerSkin != null:
		TrainerSkin.look(dir)
