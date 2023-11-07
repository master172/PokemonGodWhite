extends Control

var current_selected:int = 0
var max_selectable:int = 4

@onready var button_container = $ForeGround/ButtonContainer
@onready var backgrounds = $Backgrounds
@onready var background_continue = $Backgrounds/BackgroundContinue
@onready var background_new = $Backgrounds/BackgroundNew
@onready var loading_screen = $LoadingScreen


enum STATES {
	NORMAL,
	EMPTY
}
var state = STATES.NORMAL

func _ready():
	AudioManager.switch_to_mainMenu()
	set_selected(current_selected)
	loading_screen.hide()
	if FileAccess.file_exists("user://save/Scene/screenshot.png"):
		var img = Image.load_from_file("user://save/Scene/screenshot.png")
		var level_pic_tex = ImageTexture.create_from_image(img)
		background_continue.texture = level_pic_tex
	else:
		background_continue.texture = load("res://assets/Ui/MainMenu/Background.png")

func set_selected(num:int):
	button_container.get_child(num).modulate = Color(0, 1, 0.247)
	backgrounds.get_child(num).visible = true
	
	
func unset_selected(num:int):
	button_container.get_child(num).modulate = Color(1, 1,1)

	backgrounds.get_child(num).visible = false
	
	
func _input(event):
	if event.is_action_pressed("W"):

		AudioManager.input()
		unset_selected(current_selected)
		current_selected  = (current_selected +max_selectable - 1) % max_selectable
		set_selected(current_selected)
		
	elif event.is_action_pressed("S"):

		AudioManager.input()
		unset_selected(current_selected)
		current_selected = (current_selected + 1) % max_selectable
		set_selected(current_selected)
	
	elif Input.is_action_just_pressed("Yes"):
		

		if current_selected == 0:
			loading_screen.show()
			loading_screen.load_game()
		elif current_selected == 1:
			if DirAccess.dir_exists_absolute("user://save/"):
				var dir_to_remove = "user://save/"
				OS.move_to_trash(ProjectSettings.globalize_path(dir_to_remove))
				print("exists")
			
			loading_screen.show()
			loading_screen.load_game()
		elif current_selected == 3:
			get_tree().quit()
