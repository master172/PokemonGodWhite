extends Node2D

var can_return:bool = true
var tile_cords
var sucess
var faliure

func process_tile(player:Node2D,check:String):
	var result = process_tilemap_collision(player,check)
	player.player_surfing(result,check)
	print(result,check)
	queue_free()
	
func process_tilemap_collision(player:Node2D,check:String):
	
	var returning_value = []
	
			
	var tilemaps = Utils.Tilemaps
	
	if tilemaps != []:
		for current_tilemap in tilemaps:
			print(current_tilemap.name)
			tile_cords = current_tilemap.local_to_map(position)
			print(tile_cords)
			sucess =  [true,position,tile_cords]
			faliure = [false,position,tile_cords]
		
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
