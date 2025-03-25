extends Area2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
const TRADE = "res://testing/Multiplayer/trade.tscn"
func _ready():
	Dialogic.connect("signal_event",trading)
	Dialogic.connect("timeline_ended",end)
	
func _interact():
	Utils.get_player().set_physics_process(false)
	Dialogic.start("trade_start")

func trading(sign:String = "") ->void:
	if sign == "StartTrading":
		Utils.save_data(false)
		var trade :PackedScene= load(TRADE)
		
		canvas_layer.add_child(trade.instantiate())
		if Utils.Menu != null and is_instance_valid(Utils.Menu):
			Utils.Menu.lock = true
		
	elif sign == "CancelTrading":
		print("canceling trading")

func end():
	get_viewport().set_input_as_handled()
	await get_tree().create_timer(0.1).timeout
	Utils.get_player().set_physics_process(true)
	Utils.Menu.lock = false
