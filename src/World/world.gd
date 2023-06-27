extends Node2D

@onready var main_tilemap = $mainTilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.tilemap = main_tilemap


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
