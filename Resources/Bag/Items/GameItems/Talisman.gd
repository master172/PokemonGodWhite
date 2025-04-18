extends Item
class_name Talisman

func _start():
	Utils.talisman_active = not(Utils.talisman_active)

func use(_pokenum:int,user:BaseItem):
	_start()
