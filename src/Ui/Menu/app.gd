extends TextureRect

const normal_background = preload("res://assets/player/ash/Smartphones/Apps/AppBase.png")
const selected_background = preload("res://assets/player/ash/Smartphones/Apps/AppGreen.png")
const disabled_background = preload("res://assets/player/ash/Smartphones/Apps/AppDisabled.png")
const disabled_selected = preload("res://assets/player/ash/Smartphones/Apps/AppDisabledSelected.png")
# Called when the node enters the scene tree for the first time.
@onready var texture_rect = $TextureRect

@export var icon:Texture
@export var disabled:bool = false
func _ready():
	if disabled == false:
		texture = normal_background
	else:
		texture = disabled_background
	texture_rect.texture = icon

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_selected(change):
	if disabled == false:
		if change == false:
			texture = normal_background
		else:
			texture = selected_background
	else:
		if change == false:
			texture = disabled_background
		else:
			texture = disabled_selected
		
