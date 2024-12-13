extends CanvasLayer

@onready var battle = $Battle
@onready var default = $Default
@onready var down_2: TouchScreenButton = $Down2
@onready var up_2: TouchScreenButton = $Up2

func _ready() -> void:
	down_2.action = "ui_down"
	up_2.action = "ui_up"
	
func pokedex_active():
	down_2.action = ""
	up_2.action = ""

func pokedex_inactive():
	down_2.action = "ui_down"
	up_2.action = "ui_up"
	
func toggle_battle(val:bool):
	battle.visible = val

func toogele_default(val:bool):
	default.visible = val
