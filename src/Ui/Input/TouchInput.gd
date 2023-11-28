extends CanvasLayer

var yes = InputEventAction.new()
var no = InputEventAction.new()
var run = InputEventAction.new()
var up = InputEventAction.new()
var down = InputEventAction.new()

func _ready():
	yes.action = "ui_accept"
	no.action = "ui_cancel"
	up.action = "ui_up"
	down.action = "ui_down"
	run.action = "Run"

func _on_circle_pressed():
	yes.pressed = true
	Input.parse_input_event(yes)


func _on_circle_released():
	yes.pressed = false
	Input.parse_input_event(yes)


func _on_cross_pressed():
	no.pressed = true
	Input.parse_input_event(no)



func _on_cross_released():
	no.pressed = false

	Input.parse_input_event(no)



func _on_up_pressed():
	up.pressed = true
	Input.parse_input_event(up)


func _on_up_released():
	up.pressed = false
	Input.parse_input_event(up)
	
func _on_down_pressed():
	down.pressed = true
	Input.parse_input_event(down)


func _on_down_released():
	down.pressed = false
	Input.parse_input_event(down)
