extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Tilemaps.append(self)


func remove_tilemap():
	Utils.Tilemaps.erase(self)
