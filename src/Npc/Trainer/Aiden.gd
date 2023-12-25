extends BaseTrainer

func check_can_battle():
	if Dialogic.VAR.Aiden.CanBattle != 1:
		queue_free()

func after_lose():
	Dialogic.VAR.Aiden.CanBattle = 0
	Dialogic.Save.save()
