extends Control

@onready var Name: Label = $MainContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Name
@onready var Loc: Label = $MainContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/Loc
@onready var texture_rect: TextureRect = $MainContainer/Panel/MarginContainer/HBoxContainer/TextureRect
@onready var panel: Panel = $MainContainer/Panel

var active:bool = false:
	set(value):
		active = value
		set_active()
		
var slot_index:int = 0:
	set(value):
		slot_index = value
		set_info(value)

func set_active():
	if active == true:
		panel.self_modulate = Color.GREEN
	else:
		panel.self_modulate = Color.WHITE

func set_info(num:int):
	var slot = Global.slot_dict[num]
	Name.text = "Save Slot: " + str(num)
	var dir =  ("user://save/"+str(slot)+"/Scene")
	var files :Dictionary = get_png_and_tres_files(dir)
	
	var scene_save:scene_saver = ResourceLoader.load(files["tres"])
	Loc.text = get_clean_filename(scene_save.scene)
	
	var img = Image.load_from_file(files["png"])
	var level_pic_tex = ImageTexture.create_from_image(img)
	texture_rect.texture = level_pic_tex
	
func get_png_and_tres_files(dir_path: String) -> Dictionary:
	var dir = DirAccess.open(dir_path)
	if dir == null:
		print("Directory not found:", dir_path)
		return {}

	var result = {
	"png": null,
	"tres": null
	}

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if not dir.current_is_dir():
			if file_name.ends_with(".png"):
				result["png"] = dir_path + "/" + file_name
			elif file_name.ends_with(".tres"):
				result["tres"] = dir_path + "/" + file_name
		file_name = dir.get_next()

	dir.list_dir_end()
	return result

func get_clean_filename(path: String) -> String:
	var file_name = path.get_file()
	var name_no_ext = file_name.get_basename()
	return name_no_ext
