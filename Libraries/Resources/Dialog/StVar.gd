extends Resource

class_name SetVariable

@export var item:Dictionary = {}

func add():
	for key in item.keys():
		var value = item[key]
#		print(key)
#		print(value)
		if Global.Global_Variables.has(key):
#			print("yes")
			Global.Global_Variables[key] = value
		else:
#			print("no")
			Global.Global_Variables[key] = value
