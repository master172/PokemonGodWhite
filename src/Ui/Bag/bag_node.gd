extends Control

@export var active = false

@onready var texture_rect = $TextureRect
@onready var icon = $HBoxContainer/Icon
@onready var Name = $HBoxContainer/Name
@onready var count = $HBoxContainer/Count

@export var item:BaseItem =null

# Called when the node enters the scene tree for the first time.

func set_item(i:BaseItem):
	item = i
	if item.sprite != null:
		icon.texture = item.sprite
	Name.text = item.Name
	count.text = str(item.count)
	
func _set_active(val:bool):
	active = val

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	texture_rect.visible = active
