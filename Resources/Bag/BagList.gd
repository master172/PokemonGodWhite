extends Resource
class_name BagList

@export var type_Hint:String = "None"
@export var items:Array[BaseItem]

func _init(type:String = "None"):
	type_Hint = type

func add_item(item:BaseItem):
	for i in items:
		if i.Name == item.Name:
			i.count += item.count
			return
	items.append(item)
