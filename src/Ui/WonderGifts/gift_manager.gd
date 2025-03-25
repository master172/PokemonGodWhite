extends Node

func _ready() -> void:
	verify_save_directory("user://WonderGifts/")
	
func start_making_gift(num:int,poke:game_pokemon,uid:String,msg:String):
	if num == -1:
		return "no gift created pokemon not selected"
	var res :String= create_wonder_gift(poke,uid,msg)
	erase_pokemon_from_list(num)
	return res
func erase_pokemon_from_list(num:int):
	AllyPokemon.erase_party_pokemon(num)
	AllyPokemon.save_data()
	
func get_wonder_gift_path():
	if OS.get_name() == "Android":
		return "/storage/emulated/0/Download/MyGift.tres"  # External storage
	else:
		return ProjectSettings.globalize_path("user://WonderGifts/MyGift.tres")  # Internal user folder
			
func create_wonder_gift(monster_res: Resource, sender_uid: String,msg:String):
	var gift = WonderGift.new()
	gift.pokemon = monster_res
	gift.uid = sender_uid
	gift.message = msg

	var err = ResourceSaver.save(gift, get_wonder_gift_path())
	if err == OK:
		print("Gift created at ", get_wonder_gift_path())
	else:
		print("Failed to create gift: ", err)
		return "could not create gift, error code " + err
	return get_wonder_gift_path()
	
func load_wonder_gift(import_path: String, current_player_uid: String) ->WonderGift :
	if not ResourceLoader.exists(import_path):
		print("Gift file not found")
		return null

	var gift: WonderGift = ResourceLoader.load(import_path)
	if not gift:
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
	
