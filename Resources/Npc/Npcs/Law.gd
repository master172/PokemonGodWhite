extends looking_trainer


func _ready():
	basic_set()
	
	if Utils.Law_defeated == true:
		self.current_dialog = self.ending_dialog
	else:
		looking_set()
		
func my_battle_finished():
	if my_battle == true:
		Utils.Law_defeated = true
		my_battle_done = true
		self.current_dialog = self.ending_dialog
		emit_signal("battle_done")
