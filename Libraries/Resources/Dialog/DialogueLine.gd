extends Resource

class_name DialogueLine

@export var Dialogs :Array[Dialog] = []

@export var Format:Dictionary = {}

func replace_symbols(index:int):
	Dialogs[index].format_text(Format)

func add_symbols_to_replace(format:Dictionary):
	Format.merge(format)
	
func remove_all_symbols():
	Format = {}
