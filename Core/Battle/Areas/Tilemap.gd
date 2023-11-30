extends TileMap

# The tile index you want to randomly place
var desiredTileIndex : int = 1  # Change this to the index of your desired tile

# The number of tiles you want to randomly place
var numberOfTiles : int = 10

func _ready():
	randomize_tiles()

func randomize_tiles():
	for i in range(numberOfTiles):
		# Generate random coordinates within the tilemap bounds
		var x = randi() % get_tilemap_width()
		var y = randi() % get_tilemap_height()

		# Set the desired tile at the random coordinates
		set_cell(1,Vector2(x, y),7, Vector2(11,14))

func get_tilemap_width() -> int:
	return get_used_rect().size.x

func get_tilemap_height() -> int:
	return get_used_rect().size.y
