extends CharacterBody2D

@export var items_to_sell:Array[BaseItem]
@onready var sprite_2d = $Sprite2D


func _ready():
	Dialogic.connect("signal_event",mart_work)


func _interact():
	Dialogic.start('Mart')
	Utils.get_player().set_physics_process(false)
	get_viewport().set_input_as_handled()

func buy():
	var mart_view = load("res://src/Ui/Mart/mart_view.tscn")
	var Mart_view = mart_view.instantiate()
	Mart_view.items = self.items_to_sell
	Utils.get_scene_manager().mart_view.add_child(Mart_view)
	Mart_view.start_display_items()
	Utils.get_player().set_physics_process(false)

func sell():
	print("sell")
	Utils.get_player().set_physics_process(true)
	
func mart_work(Sign):
	if Sign == "Buy":
		buy()
	elif Sign == "Sell":
		sell()
	elif Sign == "MartCancel":
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process(true)
