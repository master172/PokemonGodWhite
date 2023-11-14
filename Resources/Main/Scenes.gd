extends Resource
class_name scene_saver

@export var scene:String
@export var first_time_start:bool = true
@export_file var current_healing_place

func change_healing_place(value:String):
	current_healing_place = value
	
func change_scene(value:String):
	scene = value

func change_start(value:bool):
	first_time_start = value
