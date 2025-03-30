extends Node2D

@onready var ground: TileMapLayer = $ground

# The tile index you want to randomly place
var desiredTileIndex : int = 1  # Change this to the index of your desired tile

# The number of tiles you want to randomly place
var numberOfTiles : int = 10
@export var tile_cords := Vector2(0,0)
@export var source_id:int = 7
#func _ready():
	#randomize_tiles()


func get_tilemap_width() -> int:
	return ground.get_used_rect().size.x

func get_tilemap_height() -> int:
	return ground.get_used_rect().size.y
