extends Resource
class_name BaseItem

@export var type_Hint:String = "None"
@export var count:int = 1
@export var Name:String = "NONE"
@export var item:Item = null
@export var sprite:Texture2D = null
@export_multiline var Description = "None"

func pick_up():
	Inventory.pocket.pockets[type_Hint].add_item(self.duplicate())
