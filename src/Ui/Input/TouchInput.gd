extends CanvasLayer

@onready var default: Control = $Main/Right/Default
@onready var battle_movement: Control = $Main/Right/Battle
@onready var no: TouchScreenButton = $Main/Left/No

@onready var battles:Array[Node] = [no,battle_movement]

var is_pokedex_active = false


func pokedex_active():
	is_pokedex_active = true

func pokedex_inactive():
	is_pokedex_active = false

func toggle_battle(val:bool):
	for battle in battles:
		battle.visible = val

func toogele_default(val:bool):
	default.visible = val


func _on_circle_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "dialogic_default_action"
	var event1 = InputEventAction.new()
	event1.action = "ui_accept"
	event.pressed = true
	event1.pressed = true
	Input.parse_input_event(event)
	Input.parse_input_event(event1)


func _on_circle_released() -> void:
	var event = InputEventAction.new()
	event.action = "dialogic_default_action"
	var event1 = InputEventAction.new()
	event1.action = "ui_accept"
	event.pressed = false
	event1.pressed = false
	Input.parse_input_event(event)
	Input.parse_input_event(event1)

func _on_cross_pressed() -> void:
	var event = InputEventAction.new()
	event.action = "ui_cancel"
	event.pressed = true
	Input.parse_input_event(event)


func _on_cross_released() -> void:
	var event = InputEventAction.new()
	event.action = "ui_cancel"
	event.pressed = false
	Input.parse_input_event(event)

func _on_up_pressed() -> void:
	if is_pokedex_active:
		var event = InputEventAction.new()
		event.action = "ui_up"
		event.pressed = true
		Input.parse_input_event(event)


func _on_up_released() -> void:
	if is_pokedex_active:
		var event = InputEventAction.new()
		event.action = "ui_up"
		event.pressed = false
		Input.parse_input_event(event)


func _on_down_pressed() -> void:
	if is_pokedex_active:
		var event = InputEventAction.new()
		event.action = "ui_down"
		event.pressed = true
		Input.parse_input_event(event)


func _on_down_released() -> void:
	if is_pokedex_active:
		var event = InputEventAction.new()
		event.action = "ui_down"
		event.pressed = false
		Input.parse_input_event(event)

func _ready() -> void:
	toggle_battle(false)
	if !OS.has_feature("android"):
		hide()
	else:
		show()
