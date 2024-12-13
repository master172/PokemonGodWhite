extends Node2D

func manage_events(body):
	if Utils.aiden_defeated == true:
		body.queue_free()

func manage_dialogs(Aiden):
	if Utils.Bea_met == true:
		if Utils.William_met == true:
			if Utils.aiden_defeated == false:
				Aiden.current_dialog = 'AidenInteraction'
			else:
				Aiden.current_dialog = 'AidenEnd'
		else:
			Aiden.current_dialog = 'AidenStall'
	else:
		Aiden.current_dialog = 'AidenFirst'


func _on_aiden_talk(body):
	manage_dialogs(body)
