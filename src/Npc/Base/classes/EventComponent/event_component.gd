extends Node2D
class_name EventComponent
@export var event_list:EventList

func _ready():
	get_parent().set_event_component(self)
	
func start():
	for i in event_list.events:
		if i is DialogEvent:
			manage_dailog_event(i)

func manage_dailog_event(event):
	Utils.Player.set_physics_process(false)
	Dialogic.timeline_ended.connect(dialog_event_over)
	Dialogic.start(event.dialog_string)
	get_viewport().set_input_as_handled()
	
func dialog_event_over():
	Dialogic.timeline_ended.disconnect(dialog_event_over)
	get_tree().create_timer(0.1).timeout
	Utils.Player.set_physics_process(true)
	
