extends Control


@onready var file_dialog = FileDialog.new()

signal file_found(path:String)
signal cancelled_file_pick

func _ready() -> void:
	add_child(file_dialog)
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.filters = PackedStringArray(["*.tres"])
	file_dialog.title = "Select a Wonder Gift to Import"
	file_dialog.confirmed.connect(_on_import_selected)
	file_dialog.canceled.connect(_on_file_dialog_canceled)

func import_gift():
	file_dialog.popup_centered()

func _on_import_selected():
	var path = file_dialog.get_current_path()
	print("Selected gift file: ", path)
	emit_signal("file_found",path)
	# Load and process the gift

func _on_file_dialog_canceled():
	AudioManager.cancel()
	emit_signal("cancelled_file_pick")
