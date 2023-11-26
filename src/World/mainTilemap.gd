extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Tilemaps.append(self)

func remove_tilemap():

	Utils.Tilemaps.erase(self)

func _on_area_0_tree_exiting():
	remove_tilemap()


func _on_cave_of_begginings_tree_exiting():
	remove_tilemap()


func _on_cave_of_begginings_bf_tree_exiting():
	remove_tilemap()


func _on_fivis_town_tree_exiting():
	remove_tilemap()


func _on_fivis_beach_tree_exiting():
	remove_tilemap()
