extends BaseTrainer

func check_can_battle():
	if Utils.aiden_defeated == true:
		queue_free()

func after_lose():
	Utils.aiden_defeated = true
	Utils.save_data()

func check_for_event_alterations():
	if Utils.aiden_defeated == false:
		if Utils.Bea_met == false:
			event_component.event_list.events[0].dialog_string = "AidenFirst"
			return
		if Utils.William_met == false:
			event_component.event_list.events[0].dialog_string = "AidenStall"
			return
		else:
			event_component.event_list.events[0].dialog_string = "AidenInteraction"
	else:
		event_component.event_list = losing_event_list
		event_component.reset()
