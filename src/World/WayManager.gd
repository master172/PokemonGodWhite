extends Node2D

@export_file var my_scene = ""
@export var to_add_parent:Node2D

var scene_loaded :Node2D = null
var loaded_scene:bool = false

var scene_load_status = 0
var progress = []
var can_load_scene:bool = false
var scenemanger:bool = true

@onready var area = $Area

func _ready():
	if scenemanger != true:
		return
	
	Utils.get_scene_manager().connect("data_set_finished",set_loadable)

func set_loadable():
	can_load_scene = true
	area.monitoring = true
	
func load_scene(body):
	if body.is_in_group("Player"):
		if my_scene != "" and loaded_scene == false and can_load_scene == true:
			ResourceLoader.load_threaded_request(my_scene)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(my_scene)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(my_scene)
		var scene = new_scene.instantiate()
		to_add_parent.add_child(scene)
		scene_loaded = scene
		loaded_scene = true


	
func unload_scene(body):
	if body.is_in_group("Player"):
		if scene_loaded != null:
			if scene_loaded.has_method("remove_tilemap"):
				scene_loaded.remove_tilemap()
			scene_loaded.call_deferred("queue_free")
			print("freed_scene")
			loaded_scene = false
