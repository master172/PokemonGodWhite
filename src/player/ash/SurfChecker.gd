extends Node2D

var can_return:bool = true

	
func process_tile(player:Node2D,check:String):
	var result = process_tilemap_collision(player,check)
	player.player_surfing(result,check)
	#print(result,check)
	queue_free()
	
func process_tilemap_collision(player:Node2D,check:String):
	
	var returning_value = []
	var current_tilemap = Utils.Tilemap
	
	if current_tilemap != null:
	
		
		var node_global_position = global_position

		var tilemap_global_position = current_tilemap.global_position

		
		var offset = node_global_position - tilemap_global_position

		
		var tilemap_offset = current_tilemap.position

		
		var tilemap_coord = offset - tilemap_offset

		
		var tile_size = Vector2(16, 16)

	
		var tile_cords = offset / tile_size

		print(tile_cords)
		tile_cords = tile_cords.round()
		print(tile_cords)
		
		var sucess =  [true,position,tile_cords]
		var faliure = [false,position,tile_cords]
	
		for index in current_tilemap.get_layers_count():
			
			if index == 1:
				var scene_tile = current_tilemap.get_cell_source_id(index,tile_cords)
				if scene_tile != -1:
					#print(scene_tile)
					if scene_tile == 6 or scene_tile == 3:
						can_return = false
					else:
						can_return = true
				
			var tile_data = current_tilemap.get_cell_tile_data(index,tile_cords)
			
			if tile_data:
				if check == "surf":
					returning_value.append(tile_data.get_custom_data("water"))

				elif check == "shore":
					returning_value.append(tile_data.get_custom_data("land"))

		

		if check == "shore":
			if returning_value != [true] or can_return == false:
				#print(returning_value)
				return faliure
			return sucess

		elif check == "surf":
			if returning_value != [true] or can_return == false:
				#print(returning_value)
				return faliure
			return sucess
	else:
			return [false]



