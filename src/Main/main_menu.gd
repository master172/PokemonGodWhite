extends Control

var current_selected:int = 0
var max_selectable:int = 6

@onready var button_container = $ForeGround/ButtonContainer
@onready var backgrounds = $Backgrounds
@onready var background_continue = $Backgrounds/BackgroundContinue
@onready var background_new = $Backgrounds/BackgroundNew
@onready var loading_screen = $LoadingScreen
@onready var confirm_panel = $ConfirmPanel
@onready var h_box_container = $ConfirmPanel/VBoxContainer/HBoxContainer
@onready var settings = $Settings
@onready var label = $ForeGround/ButtonContainer/NewGame/Label
@onready var Continue = $ForeGround/ButtonContainer/Continue
@onready var background_load_game: TextureRect = $Backgrounds/BackgroundLoadGame
@onready var Button_load_game: Panel = $ForeGround/ButtonContainer/LoadGame

@onready var load_game: Control = $LoadGame


enum STATES {
	NORMAL,
	EMPTY,
	CONFIRM,
	OPTIONS,
	LOAD_GAME
}
var state = STATES.NORMAL

var disabled_color = Color(0.345, 0.361, 0.353)
var not_selectable = Color.RED
var continue_disabled:bool = false

var loading:bool = false

var WonderGiftsPath = "user://WonderGifts/"

var previous_selected:int = 0
var previous_max_selectable:int = 0

func _ready():
	settings.visible = false
	confirm_panel.hide()
	AudioManager.switch_to_mainMenu()
	verify_save_directory(WonderGiftsPath)
	loading_screen.hide()
	if FileAccess.file_exists("user://save/"+str(Global.current_load_path)+"/Scene/"+"screenshot.png"):
		var img = Image.load_from_file("user://save/"+str(Global.current_load_path)+"/Scene/"+"screenshot.png")
		var level_pic_tex = ImageTexture.create_from_image(img)
		background_continue.texture = level_pic_tex
		background_load_game.texture = level_pic_tex
		continue_disabled = false
		Continue.self_modulate = Color(1, 1, 1)
		Button_load_game.self_modulate = Color(1,1,1)
	else:
		background_continue.texture = load("res://assets/Ui/MainMenu/Background.png")
		continue_disabled = true
		Button_load_game.self_modulate = disabled_color
		Continue.self_modulate = disabled_color
	set_selected(current_selected)
	
func set_selected(num:int):
	if num != 0 and num != 5 and num != 2:
		button_container.get_child(num).modulate = Color(0, 1, 0.247)
	elif num == 0:
		if continue_disabled == false:
			button_container.get_child(num).modulate = Color(0, 1, 0.247)
		else:
			button_container.get_child(num).modulate = not_selectable
	elif num == 5:
		if continue_disabled == false:
			button_container.get_child(num).modulate = Color(0, 1, 0.247)
		else:
			button_container.get_child(num).modulate = not_selectable
	elif num == 2:
		if continue_disabled == false:
			button_container.get_child(num).modulate = Color(0, 1, 0.247)
		else:
			button_container.get_child(num).modulate = not_selectable
	backgrounds.get_child(num).visible = true
	
	
func unset_selected(num:int):
	button_container.get_child(num).modulate = Color(1, 1,1)

	backgrounds.get_child(num).visible = false
	
	
func _input(event):
	if event.is_action_pressed("W"):
		if state == STATES.NORMAL:
			AudioManager.input()
			unset_selected(current_selected)
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			set_selected(current_selected)
		elif state == STATES.LOAD_GAME:
			AudioManager.input()
			unset_load_slot()
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			set_load_slot()
	elif event.is_action_pressed("A"):
		if state == STATES.CONFIRM:
			AudioManager.input()
			unset_confirm(current_selected)
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			set_confirm(current_selected)
		elif state == STATES.LOAD_GAME:
			AudioManager.cancel()
			unset_load_slot()
			current_selected = 2
			max_selectable = 6
			state = STATES.NORMAL
			load_game.active = false
			
	elif event.is_action_pressed("S"):
		if state == STATES.NORMAL:
			AudioManager.input()
			unset_selected(current_selected)
			current_selected = (current_selected + 1) % max_selectable
			set_selected(current_selected)
		elif state == STATES.LOAD_GAME:
			AudioManager.input()
			unset_load_slot()
			current_selected = (current_selected + 1) % max_selectable
			set_load_slot()
			
	elif event.is_action_pressed("D"):
		if state == STATES.CONFIRM:
			AudioManager.input()
			unset_confirm(current_selected)
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			set_confirm(current_selected)
	
	elif event.is_action_pressed("Yes"):
		AudioManager.select()
		if state == STATES.NORMAL:

			if current_selected == 0:
				if continue_disabled == false and loading == false:
					loading = true
					state = STATES.EMPTY
					loading_screen.show()
					loading_screen.load_game()
			elif current_selected == 1:

				loading = true
				new_game()
			elif current_selected == 2:
				if continue_disabled == false and loading == false:
					current_selected = 0
					max_selectable = count_save_folders()
					state = STATES.LOAD_GAME
					load_game.active = true
					set_load_slot()
			elif current_selected == 3:
				settings.visible = true
				state = STATES.OPTIONS
			elif current_selected == 4:
				Global.save_config_file()
				get_tree().quit()
			elif current_selected == 5:
				if continue_disabled == false:
					get_tree().change_scene_to_file("res://src/Ui/WonderGifts/wonder_gifts.tscn")
				else:
					AudioManager.cancel()
			
		elif state == STATES.CONFIRM:
			if current_selected == 0:
				if loading == false:
					if previous_max_selectable <= 1:
						AudioManager.cancel()
					else:
						delete_slot()
			elif current_selected == 1:
				current_selected = previous_selected
				max_selectable = previous_max_selectable
				confirm_panel.hide()
				state = STATES.LOAD_GAME
				previous_selected = 0
				previous_max_selectable = 0
		elif state == STATES.LOAD_GAME:
			Global.current_load_path = Global.slot_dict[current_selected]
			load_game.active = false
			loading = true
			state = STATES.EMPTY
			loading_screen.show()
			loading_screen.load_game()
			
	elif event.is_action_pressed("No"):
		AudioManager.cancel()
		if state == STATES.LOAD_GAME:
			previous_selected = current_selected
			previous_max_selectable = max_selectable
			current_selected = 1
			max_selectable = 2
			state = STATES.CONFIRM
			confirm_panel.show()
			unset_confirm(0)
			unset_confirm(1)
			set_confirm(current_selected)
		elif state == STATES.CONFIRM:
			state = STATES.LOAD_GAME
			confirm_panel.hide()
			max_selectable = previous_max_selectable
			current_selected = previous_selected
			previous_max_selectable = 0
			previous_selected = 0

func delete_slot():
	var slot = Global.slot_dict[previous_selected]
	Utils.remove_save_files(slot)
	Global.delete_save_slot(previous_selected)
	#Global.current_load_path = Global.slot_dict[previous_selected-1]
	
	load_game.delete_slot(previous_selected)
	confirm_panel.hide()
	current_selected = previous_selected
	max_selectable = previous_max_selectable
	max_selectable -=1
	current_selected = clamp(current_selected-1,0,max_selectable)
	previous_selected = 0
	previous_max_selectable = 0
	state = STATES.LOAD_GAME
	
func new_game():
	Global.current_load_path = int(Time.get_unix_time_from_system())
	state = STATES.EMPTY
	#Utils.remove_save_files()
	
	loading_screen.show()
	loading_screen.load_intro()

func unset_confirm(num:int = 0):
	h_box_container.get_child(num).modulate = Color(1,1,1)

func set_confirm(num:int = 0):
	h_box_container.get_child(num).modulate = Color(0, 1, 0.275)


func _on_settings_visibility_changed():
	if settings.visible == false:
		state = STATES.NORMAL

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)

func count_save_folders() -> int:
	var dir = DirAccess.open("user://save")
	if dir == null:
		print("Directory not found.")
		return 0

	var folder_count = 0
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if dir.current_is_dir() and file_name != "." and file_name != "..":
			folder_count += 1
		file_name = dir.get_next()

	dir.list_dir_end()
	return folder_count

func unset_load_slot():
	load_game.unset_selected(current_selected)

func set_load_slot():
	load_game.set_selected(current_selected)
	load_game.scroll(current_selected)
