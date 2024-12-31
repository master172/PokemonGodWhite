extends looking_trainer

func _ready():
	basic_set()
	
	if Utils.kyle_defeated == true:
		current_dialog = ending_dialog
	else:
		current_dialog = current_dialog
		looking_set()

func my_battle_finished():
	if my_battle == true:
		print("is this the cause?")
		Utils.kyle_defeated = true
		my_battle_done = true
		self.current_dialog = self.ending_dialog
		emit_signal("battle_done")
