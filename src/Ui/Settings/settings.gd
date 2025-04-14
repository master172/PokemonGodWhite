extends Control

var save_file_path = "user://save/"
var save_file_name = "Settings.tres"

var Settings_Saver:settings_saver = settings_saver.new()

@onready var vsync_button = $TabContainer/Display/ScrollContainer/VBoxContainer/Panel/VsyncButton
@onready var speed_button = $TabContainer/Engine/ScrollContainer/VBoxContainer/Panel/SpeedButton
@onready var volume_slider = $TabContainer/Audio/ScrollContainer/VBoxContainer/Panel/VolumeSlider

func _ready():
	verify_save_directory(save_file_path)
	load_data()
	
func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_data():
	ResourceSaver.save(Settings_Saver,save_file_path + save_file_name)

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		Settings_Saver = ResourceLoader.load(save_file_path + save_file_name)
		apply_data()

func apply_data():
	speed_button.selected = Settings_Saver.speed_scale - 1
	vsync_button.selected = Settings_Saver.v_sync_mode
	volume_slider.value = Settings_Saver.master_audio
	set_settings()
	
func set_settings():
	Engine.set_time_scale(float(Settings_Saver.speed_scale))
	DisplayServer.window_set_vsync_mode(Settings_Saver.v_sync_mode)
	#print(Engine.get_time_scale())
	
func _on_option_button_item_selected(index):
	Engine.set_time_scale(float(index+1))


func _on_vsync_button_item_selected(index):
	DisplayServer.window_set_vsync_mode(index)


func _on_button_pressed():
	Settings_Saver.speed_scale = speed_button.selected + 1
	Settings_Saver.v_sync_mode = vsync_button.selected
	Settings_Saver.master_audio = volume_slider.value
	save_data()
	visible = false
