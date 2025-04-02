extends Node
class_name BadgeHandler

@export var BadgeSignal :String = ""
@export var badge_count :int = 1

func _ready():
	Dialogic.connect("signal_event",check)

func check(Sign):

	if Sign == BadgeSignal:
		Utils.Badge_count += badge_count
