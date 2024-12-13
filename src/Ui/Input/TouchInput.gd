extends CanvasLayer

@onready var battle = $Battle
@onready var default = $Default
#
#var yes = InputEventAction.new()
#var no = InputEventAction.new()
#var run = InputEventAction.new()
##var up = InputEventAction.new()
##var down = InputEventAction.new()
##var move_up = InputEventAction.new()
##var move_down = InputEventAction.new()
#
#func _ready():
	#yes.action = "ui_accept"
	#no.action = "ui_cancel"
	##up.action = "ui_up"
	##down.action = "ui_down"
	#run.action = "Run"
	##move_up.action = "W"
	##move_down.action = "S"
#
#func _on_circle_pressed():
	#yes.pressed = true
	#Input.parse_input_event(yes)
#
#
#func _on_circle_released():
	#yes.pressed = false
	#Input.parse_input_event(yes)
#
#
#func _on_cross_pressed():
	#no.pressed = true
	#Input.parse_input_event(no)
#
#
#
#func _on_cross_released():
	#no.pressed = false
#
	#Input.parse_input_event(no)
#

#
#func _on_up_pressed():
	#up.pressed = true
	#move_up.pressed = true
	#Input.parse_input_event(up)
	#Input.parse_input_event(move_up)
#
#
#func _on_up_released():
	#up.pressed = false
	#move_up.pressed = false
	#Input.parse_input_event(up)
	#Input.parse_input_event(move_up)
	#
#func _on_down_pressed():
	#down.pressed = true
	#move_down.pressed = true
	#Input.parse_input_event(down)
	#Input.parse_input_event(move_down)
#
#
#func _on_down_released():
	#down.pressed = false
	#move_down.pressed = false
	#Input.parse_input_event(down)
	#Input.parse_input_event(move_down)

func toggle_battle(val:bool):
	battle.visible = val

func toogele_default(val:bool):
	default.visible = val
