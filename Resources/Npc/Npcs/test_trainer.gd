extends spinning_trainer

func _ready():
	basic_set()
	
	looking_set()
	spinning_set()
		
func my_battle_finished():
	if my_battle == true:
		Utils.Lisa_defeated = true
		my_battle_done = true
		self.current_dialog = self.ending_dialog
		emit_signal("battle_done")
