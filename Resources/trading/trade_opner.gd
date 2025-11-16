extends Area2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
const TRADE = "res://src/Ui/Trading/WSS/trade_ui.tscn"

var interacting:bool = false

func _ready():
	Dialogic.connect("signal_event",trading)
	Dialogic.connect("timeline_ended",end)
	
func _interact():
	interacting = true
	Utils.get_player().set_physics_process(false)
	Dialogic.start("trade_start")

func trading(sign_type:String = "") ->void:
	if sign_type == "StartTrading":
		Utils.save_data(false)
		var trade :PackedScene= load(TRADE)
		var trade_scne = trade.instantiate()
		canvas_layer.add_child(trade_scne)
		trade_scne.connect("tree_exiting",finish_trading)
		if Utils.Menu != null and is_instance_valid(Utils.Menu):
			Utils.Menu.lock = true
		interacting = false
	elif sign_type == "CancelTrading":
		print("canceling trading")

func finish_trading():
	interacting = true
	end()
	
func end():
	if interacting == true:
		get_viewport().set_input_as_handled()
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process(true)
		Utils.Menu.lock = false
		interacting = false
