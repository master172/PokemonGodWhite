extends Control

@onready var save_dialog = FileDialog.new()

var pokemon:game_pokemon = null
var uid:String = ""
var msg:String = ""
var to_delete:int = -1
func _ready():
	add_child(save_dialog)
	save_dialog.set_use_native_dialog(true)
	save_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.filters = PackedStringArray(["*.tres"])
	save_dialog.file_selected.connect(_on_save_confirmed)
	save_dialog.canceled.connect(_on_file_dialog_canceled)

func export_gift(pokemon:game_pokemon,uid:String = "",message:String = ""):
	create_gift_data(pokemon,uid,message)
	save_dialog.popup_centered()

func create_gift_data(poke:game_pokemon,UID:String = "",message:String = ""):
	pokemon = poke
	uid = UID
	msg = message

func _on_save_confirmed(export_path):
	AudioManager.select()
	if export_path == "":
		OS.alert("Filename cannot be empty!")
		return
		
	var wonder_gift = WonderGift.new()
	wonder_gift.pokemon = pokemon
	wonder_gift.uid = uid
	wonder_gift.message = msg
	
	if not export_path.ends_with(".tres"):
		export_path += ".tres"

	# Save the resource using ResourceSaver
	var err = ResourceSaver.save(wonder_gift, export_path)
	if err == OK:
		OS.alert("Gift saved to:\n" + export_path)
		erase_pokemon_from_list(to_delete)
	else:
		OS.alert("Failed to save gift! Error code: %d" % err)
		
func _on_gift_manager_export_gift(my_pokemon: game_pokemon, uid: String, message: String,num:int) -> void:
	export_gift(my_pokemon,uid,message)
	to_delete = num
	
func erase_pokemon_from_list(num:int):
	AllyPokemon.erase_party_pokemon(num)
	AllyPokemon.save_data()
	to_delete = -1

func _on_file_dialog_canceled():
	AudioManager.cancel()
