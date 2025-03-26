extends Control

@onready var save_dialog = FileDialog.new()

var pokemon:game_pokemon = null
var uid:String = ""
var msg:String = ""

func _ready():
	add_child(save_dialog)
	save_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.filters = PackedStringArray(["*.tres"])
	save_dialog.confirmed.connect(_on_save_confirmed)

func export_gift(pokemon:game_pokemon,uid:String = "",message:String = ""):
	create_gift_data(pokemon,uid,message)
	save_dialog.popup_centered()

func create_gift_data(poke:game_pokemon,UID:String = "",message:String = ""):
	pokemon = poke
	uid = UID
	msg = message

func _on_save_confirmed():
	var export_path = save_dialog.get_current_path()
	# Create or load your WonderGiftResource (a custom Resource you defined)
	var wonder_gift = WonderGift.new()
	wonder_gift.pokemon = pokemon
	wonder_gift.uid = uid
	wonder_gift.message = msg

	# Optional: Ensure the file extension is .tres or .res
	if not export_path.ends_with(".tres"):
		export_path += ".tres"

	# Save the resource using ResourceSaver
	var err = ResourceSaver.save(wonder_gift, export_path)
	if err == OK:
		OS.alert("Gift saved to:\n" + export_path)
	else:
		OS.alert("Failed to save gift! Error code: %d" % err)

func _on_gift_manager_export_gift(my_pokemon: game_pokemon, uid: String, message: String) -> void:
	export_gift(my_pokemon,uid,message)
	
