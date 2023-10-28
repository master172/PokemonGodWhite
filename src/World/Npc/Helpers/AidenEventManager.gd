extends Node2D

func manage_events(body):
	if Utils.aiden_defeated == true:
		body.queue_free()
