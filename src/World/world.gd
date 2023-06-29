extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Tilemap = get_node("%mainTilemap")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
