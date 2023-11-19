extends trainer

func my_battle_finished():
	if my_battle == true:
		Utils.aiden_defeated = true
		my_battle_done = true
		self.current_dialog = self.ending_dialog
		emit_signal("battle_done")
