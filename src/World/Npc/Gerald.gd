extends CharacterBody2D

var current_dialog:DialogueLine

@export var first_dialog:DialogueLine
@export var normal_dialog:DialogueLine
var first_dialog_finished:bool = false

@export var items_to_sell:Array[BaseItem]
@onready var sprite_2d = $Sprite2D


func _ready():
	var dialogLayer = DialogLayer.get_child(0)
	dialogLayer.connect("finished",finish)
	dialogLayer.function_manager.connect("Buy",buy)
	dialogLayer.function_manager.connect("Sell",sell)

func look(facDir:Vector2):
	if facDir == Vector2(0,1):
		sprite_2d.frame = 0
	elif facDir == Vector2(0,-1):
		sprite_2d.frame = 12
	elif facDir == Vector2(1,0):
		sprite_2d.frame = 8
	elif facDir == Vector2(-1,0):
		sprite_2d.frame = 4
		
func _interact():
	if Utils.William_met == false:
		Utils.William_met = true
		Utils.get_player().set_physics_process(false)
		Dialogic.start('WilliamFirst')
		get_viewport().set_input_as_handled()
	else:
		current_dialog = normal_dialog
		DialogLayer.get_child(0)._start(current_dialog)
		
func finish(dial):
	if dial == current_dialog:
		if current_dialog == first_dialog:
			Utils.get_player().set_physics_process(true)

func buy():
	var mart_view = load("res://src/Ui/Mart/mart_view.tscn")
	var Mart_view = mart_view.instantiate()
	Mart_view.items = self.items_to_sell
	Utils.get_scene_manager().mart_view.add_child(Mart_view)
	Mart_view.start_display_items()
	Utils.get_player().set_physics_process(false)

func sell():
	print("sell")
