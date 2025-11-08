extends Node

const PATH = "res://Core/Pokemon"
const EXTENSION = "tres"

# Called when the node enters the scene tree for the first time.
var dir_path = "res://Core/Pokemon/"
var desired_extension = "tres"

var query_result:Array = []
var pokemon_list:Array[String]=[]

func alphabetical_query(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				if file_name.get_extension() == EXTENSION:
					var pokemon_name = file_name.get_basename()
					#var pokemon = file_name
					pokemon_list.append(pokemon_name)
					#print_debug("Found Pokemon: " + pokemon_name)
					#query_result.append(load(PATH+"/"+pokemon))
			file_name = dir.get_next()
		pokemon_list.sort()
		for i in pokemon_list:
			query_result.append(PATH+"/"+i+".tres")
		print(pokemon_list)
	else:
		print("An error occurred when trying to access the path.")
