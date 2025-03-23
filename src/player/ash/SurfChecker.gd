extends Node2D

var can_return:bool = true
var tile_cords
var sucess
var faliure

@export_flags_2d_physics var nonusebale_layers

func process_tile(player:Node2D,check:String):
	var result = process_tilemap_collision(player,check)
	player.player_surfing(result,check)
	print(result,check)
	queue_free()
	
func process_tilemap_collision(player:Node2D,check:String):
	
	var returning_value = []
	
	
	var Tilemaps = Utils.Tilemaps
	var tilemaps:Array[TileMapLayer]
	for i in Tilemaps:
		tilemaps.append(i.ground_layer)
			
	if tilemaps != []:
		for current_tilemap in tilemaps:
			print(current_tilemap.name)
			tile_cords = current_tilemap.local_to_map(position)
			print(tile_cords)
			sucess =  [true,position,tile_cords]
			faliure = [false,position,tile_cords]
			
			var query = PhysicsPointQueryParameters2D.new()
			query.position = position
			query.set_collision_mask(nonusebale_layers)
			
			var direct_state = get_world_2d().direct_space_state
			var collision = direct_state.intersect_point(query)
			
			if collision:
				can_return = false
			
			var tile_data = current_tilemap.get_cell_tile_data(tile_cords)
			
			if tile_data:
				if check == "surf":
					returning_value.append(tile_data.get_custom_data("water"))
					
				elif check == "shore":
					returning_value.append(tile_data.get_custom_data("land"))
		
		if check == "shore":
			if returning_value == [true] and can_return == true:
				#print(returning_value)
				return sucess
		elif check == "surf":
			if returning_value == [true] and can_return == true:
				#print(returning_value)
				return sucess
		return faliure
	else:
		return [false]
