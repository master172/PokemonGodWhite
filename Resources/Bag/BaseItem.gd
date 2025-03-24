extends Resource
class_name BaseItem

@export_enum(
	"general_items",
	"Medicine",
	"BattleItems",
	"Pokeballs",
	"Machines",
	"Berries",
	"KeyItems",
	"Evolution",
	"Trophys",
	"None",
) var type_Hint:String = "None"

@export var count:int = 1
@export var Name:String = "NONE"
@export var item:Item = null
@export var sprite:Texture2D = null
@export_multiline var Description = "None"
@export var price:int = 200

func pick_up():
	Inventory.pocket.pockets[type_Hint].add_item(self.duplicate())

func use(pokenum:int = 0):
	item.use(pokenum,self)

func set_count(num:int):
	count += num
	if count == 0:
		Inventory.pocket.pockets[type_Hint].erase(self)
