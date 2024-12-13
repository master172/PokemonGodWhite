extends Node2D



@export var BadgeSignal :String = ""
@export var badge_count :int = 0

func _ready():
	Dialogic.connect("signal_event",check)

func check(Sign):

	if Sign == BadgeSignal:
		Utils.Badge_count = badge_count

