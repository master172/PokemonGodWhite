extends Control


@onready var file_dialog = FileDialog.new()

signal file_found(path:String)
signal cancelled_file_pick
signal return_normal

func _ready() -> void:
	add_child(file_dialog)
	file_dialog.set_use_native_dialog(true)
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.filters = PackedStringArray(["*.tres"])
	file_dialog.title = "Select a Wonder Gift to Import"
	file_dialog.file_selected.connect(_on_import_selected)
	file_dialog.canceled.connect(_on_file_dialog_canceled)

func import_gift():
	file_dialog.popup_centered()

func _on_import_selected(path):
	print("are we even reaching here")
	if path == "":
		OS.alert("No file selected!")
		emit_signal("return_normal")
		return
	
	if not path.ends_with(".tres"):
		OS.alert("Invalid file type! Please select a .tres file")
		emit_signal("return_normal")
		return
	
	print("Selected gift file: ", path)
	emit_signal("file_found",path)
	# Load and process the gift

func _on_file_dialog_canceled():
	AudioManager.cancel()
	emit_signal("cancelled_file_pick")
