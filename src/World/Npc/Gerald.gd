extends CharacterBody2D

var current_dialog:DialogueLine

@export var first_dialog:DialogueLine
@export var normal_dialog:DialogueLine
var first_dialog_finished:bool = false

@export var items_to_sell:Array[BaseItem]


func _ready():
	var dialogLayer = DialogLayer.get_child(0)
	dialogLayer.connect("finished",finish)
	dialogLayer.function_manager.connect("Buy",buy)
	dialogLayer.function_manager.connect("Sell",sell)
	
func _interact():
	if first_dialog_finished == false:
		current_dialog = first_dialog
		DialogLayer.get_child(0)._start(current_dialog)
		
		first_dialog_finished = true
		
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
