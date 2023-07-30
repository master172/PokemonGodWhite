extends Node

var Tilemap = null
var DialogBar = null
var Player = null

var DialogProcessing:bool = false

func get_player():
	if get_tree().get_current_scene().name == "SceneManager":
		return get_node("/root/SceneManager/Current_scene").get_children().back().get_node("player")
	else:
		var to_return = get_tree().get_nodes_in_group("Player")
		if to_return.size() >= 1:
			return to_return[0]
	return null
	
func get_scene_manager():
	if get_tree().get_current_scene().name == "SceneManager":
		return get_node("/root/SceneManager")
	return null

func set_player(set_see:bool = true):
	
	var player = get_player()
	if player != null:
		player.check_to_add_overworld_pokemon(set_see)

func save_data():
	get_player().save_data()
	get_scene_manager().save_data()
	AllyPokemon.save_data()
