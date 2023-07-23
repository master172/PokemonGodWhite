extends Resource
class_name scene_saver

@export var scene:String
@export var first_time_start:bool = true

func change_scene(value:String):
	scene = value

func change_start(value:bool):
	first_time_start = value
