extends Resource
class_name Pockets

@export var general_items:BagList = BagList.new("General_Items")
@export var Medicine:BagList = BagList.new("Medicine")
@export var BattleItems:BagList = BagList.new("Battle_Items")
@export var Pokeballs:BagList = BagList.new("PokeBalls")
@export var Machines:BagList = BagList.new("Machines")
@export var Berries:BagList = BagList.new("Berries")
@export var KeyItems:BagList = BagList.new("KeyItems")
@export var Evolution:BagList = BagList.new("Evolution")

@export var pockets :Dictionary = {
	"general_items":general_items,
	"Medicine":Medicine,
	"BattleItems":BattleItems,
	"Pokeballs":Pokeballs,
	"Machines":Machines,
	"Berries":Berries,
	"KeyItems":KeyItems,
	"Evolution":Evolution,
}
