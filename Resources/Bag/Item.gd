extends Resource
class_name Item

enum function {
	POKEMON_USING,
	POKEMON_HOLDING,
	GENERAL
}
@export var my_function:function = 2
func _start():
	pass

func get_function():
	return my_function

func use(pokenum:int,user:BaseItem):
	pass
