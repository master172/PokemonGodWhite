extends Control

func _ready():
	visible = false

@onready var dev_terminal: Control = $DevTerminal

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		visible = not visible
		dev_terminal.visible = visible
		if visible:
			Utils.get_player().set_physics_process(false)
		else:
			Utils.get_player().set_physics_process(true)
