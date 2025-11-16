extends Node
class_name TradeFinisher


const base_save_file_path := "user://Trade/"
const save_file_name := "Pokemon.tres"
const base_path_to_temp := "user://Temp/"
const temp_file_name := "tradedpokemon.tres"

func export_pokemon(pokemon:game_pokemon) ->String:
	var save_file_path:String = base_save_file_path + str(Global.current_load_path) + "/"
	DirAccess.make_dir_recursive_absolute(save_file_path)
	ResourceSaver.save(pokemon, save_file_path + save_file_name)
	var bytes:PackedByteArray = FileAccess.get_file_as_bytes(save_file_path + save_file_name)
	var encoded_string = Marshalls.raw_to_base64(bytes)
	return encoded_string

func receive_resource_file(bytes:String)->game_pokemon:
	var encoded_bytes :PackedByteArray= Marshalls.base64_to_raw(bytes)
	var path_to_temp:String = base_path_to_temp + str(Global.current_load_path) + "/"
	DirAccess.make_dir_recursive_absolute(path_to_temp)
	var file = FileAccess.open(path_to_temp + temp_file_name, FileAccess.WRITE)
	file.store_buffer(encoded_bytes)
	file.close()
	var traded_pokemon :game_pokemon = ResourceLoader.load(path_to_temp + temp_file_name)
	return traded_pokemon

#region dir stuff
func remove_directires():
	if DirAccess.dir_exists_absolute("user://Trade/"+str(Global.current_load_path)+"/"):
		var dir = DirAccess.open("user://Trade/"+str(Global.current_load_path)+"/")
		var files = dir.get_files()
		for file in files:
			dir.remove(file)
		dir.remove("user://Trade/"+str(Global.current_load_path)+"/")
		
	if DirAccess.dir_exists_absolute("user://Temp/"+str(Global.current_load_path)+"/"):
		var dir = DirAccess.open("user://Temp/"+str(Global.current_load_path)+"/")
		var files = dir.get_files()
		for file in files:
			dir.remove(file)
		dir.remove("user://Temp/"+str(Global.current_load_path)+"/")
#endregion
