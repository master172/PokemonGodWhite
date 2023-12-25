extends Node2D
class_name EventComponent
@export var event_list:EventList

signal look_dir_changed(dir)
signal event_over
signal Battle

var battling:bool = false

var event_index:int = 0
func _ready():
	get_parent().set_event_component(self)
	
func start():
	if battling == false:
		if event_index > event_list.events.size()-1:
			event_index = 0
			return
			
		var i = event_list.events[event_index]
		if i is DialogEvent:
			manage_dailog_event(i)
		elif i is LookEvent:
			manage_look_event(i)

func manage_look_event(event):
	emit_signal("look_dir_changed",event.dir)
	event_index += 1
	emit_signal("event_over")
	start()
	
func manage_dailog_event(event):
	Utils.Player.set_physics_process(false)
	
	Dialogic.timeline_ended.connect(dialog_event_over)
	Dialogic.signal_event.connect(check_for_battle)
	
	Dialogic.start(event.dialog_string)
	get_viewport().set_input_as_handled()
	
func dialog_event_over():
	Dialogic.timeline_ended.disconnect(dialog_event_over)
	Dialogic.signal_event.disconnect(check_for_battle)
	event_index += 1
	get_viewport().set_input_as_handled()
	get_tree().create_timer(0.2).timeout
	
	Utils.Player.set_physics_process(true)
	emit_signal("event_over")
	start()

func check_for_battle(Sign):
	if Sign == "Battle":
		emit_signal("Battle")
		battling = true

func reset():
	battling = false
	event_index = 0
