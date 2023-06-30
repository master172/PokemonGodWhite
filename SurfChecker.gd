extends Node2D


func process_tile(player:Node2D,check:String):
	var result = process_tilemap_collision(player,check)
	player.player_surfing(result,check)
	queue_free()
	
func process_tilemap_collision(player:Node2D,check:String):
	var returning_value = []
	var current_tilemap = Utils.Tilemap
	
	if current_tilemap != null:
	
		var tile_cords = current_tilemap.local_to_map(position)
		
		for index in current_tilemap.get_layers_count():
			var tile_data = current_tilemap.get_cell_tile_data(index,tile_cords)
			
			if tile_data:
				if check == "surf":
					returning_value.append(tile_data.get_custom_data("water"))

				elif check == "shore":
					returning_value.append(tile_data.get_custom_data("land"))
			else:
				return "no tiles"


		var sucess =  [true,position,tile_cords]
		var faliure = [false,position,tile_cords]

		if check == "shore":
			if returning_value != [true]:
				return faliure
			return sucess

		elif check == "surf":
			if returning_value != [true]:
				return faliure
			return sucess
	else:
			return "no tiles"
