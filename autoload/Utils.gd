extends Node

var Tilemap = null
var DialogBar = null
var Player = null

var DialogProcessing:bool = false

func get_player():
	return get_node("/root/SceneManager/Current_scene").get_children().back().get_node("player")

func get_scene_manager():
	return get_node("/root/SceneManager")
