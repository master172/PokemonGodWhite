extends Control

@onready var background = $Background
@onready var item_pane = $HBoxContainer/ItemPane
@onready var Name = $HBoxContainer/Name
@onready var price = $HBoxContainer/Price

var item:BaseItem

func _prepare():
	item_pane.texture = item.sprite
	Name.text = item.Name
	price.text = str(item.price)
func _unactive():
	background.self_modulate = Color(0, 0, 0, 0)
	
func _active():
	background.self_modulate = Color(0, 0, 0, 1)
