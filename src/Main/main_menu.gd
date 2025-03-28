extends Control

var current_selected:int = 0
var max_selectable:int = 5

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


enum STATES {
	NORMAL,
	EMPTY,
	CONFIRM,
	OPTIONS
}
var state = STATES.NORMAL

var disabled_color = Color(0.345, 0.361, 0.353)
var not_selectable = Color.RED
var continue_disabled:bool = false

var loading:bool = false

var WonderGiftsPath = "user://WonderGifts/"


func _ready():
	settings.visible = false
	confirm_panel.hide()
	AudioManager.switch_to_mainMenu()
	verify_save_directory(WonderGiftsPath)
	loading_screen.hide()
	if FileAccess.file_exists("user://save/Scene/screenshot.png"):
		var img = Image.load_from_file("user://save/Scene/screenshot.png")
		var level_pic_tex = ImageTexture.create_from_image(img)
		background_continue.texture = level_pic_tex
		continue_disabled = false
		Continue.self_modulate = Color(1, 1, 1)
	else:
		background_continue.texture = load("res://assets/Ui/MainMenu/Background.png")
		continue_disabled = true
		
		Continue.self_modulate = disabled_color
	set_selected(current_selected)
func set_selected(num:int):
	if num != 0 and num != 4:
		button_container.get_child(num).modulate = Color(0, 1, 0.247)
	elif num == 0:
		if continue_disabled == false:
			button_container.get_child(num).modulate = Color(0, 1, 0.247)
		else:
			button_container.get_child(num).modulate = not_selectable
	elif num == 4:
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
	elif event.is_action_pressed("A"):
		if state == STATES.CONFIRM:
			AudioManager.input()
			unset_confirm(current_selected)
			current_selected  = (current_selected +max_selectable - 1) % max_selectable
			set_confirm(current_selected)
		
	elif event.is_action_pressed("S"):
		if state == STATES.NORMAL:
			AudioManager.input()
			unset_selected(current_selected)
			current_selected = (current_selected + 1) % max_selectable
			set_selected(current_selected)
			
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
				current_selected = 1
				max_selectable = 2
				state = STATES.CONFIRM
				confirm_panel.show()
				unset_confirm(0)
				unset_confirm(1)
				set_confirm(current_selected)
			elif current_selected == 2:
				settings.visible = true
				state = STATES.OPTIONS
			elif current_selected == 3:
				get_tree().quit()
			elif current_selected == 4:
				if continue_disabled == false:
					get_tree().change_scene_to_file("res://src/Ui/WonderGifts/wonder_gifts.tscn")
				else:
					AudioManager.cancel()
			
		elif state == STATES.CONFIRM:
			if current_selected == 0:
				if loading == false:
					new_game()
					confirm_panel.hide()
					loading = true
			elif current_selected == 1:
				current_selected = 1
				max_selectable = 4
				confirm_panel.hide()
				state = STATES.NORMAL
		
				

func new_game():
	state = STATES.EMPTY
	Utils.remove_save_files()
	
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
