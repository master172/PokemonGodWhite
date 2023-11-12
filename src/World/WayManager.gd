extends Node2D

@export_file var my_scene = ""
@export var to_add_parent:Node2D

var scene_loaded :Node2D = null
var loaded_scene:bool = false

var scene_load_status = 0
var progress = []

func load_scene():
	if my_scene != "" and loaded_scene == false:
		ResourceLoader.load_threaded_request(my_scene)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(my_scene)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(my_scene)
		var scene = new_scene.instantiate()
		to_add_parent.add_child(scene)
		scene_loaded = scene
		loaded_scene = true


	
func unload_scene():
	if scene_loaded.has_method("remove_tilemap"):
		scene_loaded.remove_tilemap()
	scene_loaded.call_deferred("queue_free")
	print("freed_scene")
	loaded_scene = false
