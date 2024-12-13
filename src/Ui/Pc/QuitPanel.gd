extends Panel

@onready var yes = $VBoxContainer/HBoxContainer/Yes
@onready var no = $VBoxContainer/HBoxContainer/No
@onready var cursor_yes = $VBoxContainer/HBoxContainer/Yes/Cursor
@onready var cursor_no = $VBoxContainer/HBoxContainer/No/Cursor

signal Quit

func _ready():
	visible = false
	cursor_yes.visible = true
	cursor_no.visible = false

func set_quit_active():
	cursor_yes.visible = true
	cursor_no.visible = false
	visible = true

func set_quit_inactive():
	visible = false
	
	
func set_active(num:int):
	if num == 0:
		cursor_yes.visible = true
		cursor_no.visible = false
	elif num == 1:
		cursor_no.visible = true
		cursor_yes.visible = false

func quit():
	emit_signal("Quit")


func _on_poke_storage_quit_active():
	set_quit_active()


func _on_poke_storage_quit_cancel():
	set_quit_inactive()
