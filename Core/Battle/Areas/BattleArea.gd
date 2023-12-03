extends Node2D

const ROCK1 = preload("res://Core/Battle/Cosmetics/Rock1.tscn")

@export var numberOfTiles : int = 10
@export var NavMesh:NavigationRegion2D
@export var Tilemap:TileMap
func _ready():
	add_decorations()

func add_decorations():
	randomize_tiles()
	NavMesh.bake_navigation_polygon()
	
func randomize_tiles():
	for i in range(numberOfTiles):
		# Generate random coordinates within the tilemap bounds
		var x = randi() % get_tilemap_width()
		var y = randi() % get_tilemap_height()
		print(x," ",y)
		
		var Decor = ROCK1.instantiate()
		Decor.global_position = Vector2(x,y)*64
		NavMesh.add_child(Decor)
	return
		# Set the desired tile at the random coordinates

func get_tilemap_width() -> int:
	return Tilemap.get_used_rect().size.x

func get_tilemap_height() -> int:
	return Tilemap.get_used_rect().size.y
