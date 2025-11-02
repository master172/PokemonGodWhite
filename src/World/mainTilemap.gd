extends Node2D
class_name GameTilemap

@export var ground_layer:TileMapLayer = null
@export var ground_object_layer:TileMapLayer = null
@export var water_layer:TileMapLayer = null
@export var room_scene:Node2D = null

func _ready() -> void:
	if ground_layer == null:
		for i in get_children():
			if i is TileMapLayer:
				ground_layer = i
				break
	if ground_object_layer == null:
		for i in get_children():
			if i is TileMapLayer:
				if ground_layer != i:
					ground_object_layer = i
					break
	if room_scene == null:
		room_scene = get_parent()
	await get_parent().ready
	room_scene.tree_exiting.connect(_on_tree_exiting)
	Utils.Tilemaps.append(self)

func remove_tilemap():
	Utils.Tilemaps.erase(self)

func _on_tree_exiting():
	remove_tilemap()
