extends Node

signal export_gift(pokemon:game_pokemon,uid:String,message:String,num:int)

func _ready() -> void:
	verify_save_directory("user://WonderGifts/")
	
func start_making_gift(num:int,poke:game_pokemon,uid:String,msg:String):
	if num == -1:
		return "no gift created pokemon not selected"
	emit_signal("export_gift",poke.duplicate(),uid,msg,num)


func load_wonder_gift(import_path: String, current_player_uid: String) ->WonderGift :
	if not ResourceLoader.exists(import_path):
		print("invalid path")
		return null

	var gift: WonderGift = ResourceLoader.load(import_path)
	if not gift:
		OS.alert("failed to load gift")
		print("failed to load gift")
		return null
	#if gift.uid == Utils.player_uid:
		#print("You can't open your own gift!")
		#return null
	var gift_instance = gift.duplicate()
	# Add the monster to the player's collection
	add_monster_to_collection(gift.pokemon)
	print("successfully done")
	if FileAccess.file_exists(import_path):
		var result = DirAccess.remove_absolute(import_path)
		if result == OK:
			print("Gift file deleted successfully.")
			return gift_instance
		else:
			print("Failed to delete gift file. Error:", result)
			return gift_instance
	else:
		return gift_instance
		
func add_monster_to_collection(monster: game_pokemon):
	# Example of adding the monster to your collection
	print("Monster received:", monster.Nick_name)
	AllyPokemon.wonder_gift_open(monster)

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
	
