extends Control

@onready var password = $Panel/LoginContainer/HBoxContainer2/Password
@onready var username = $Panel/LoginContainer/HBoxContainer/Username
@onready var error = $Panel/LoginContainer/Error
@onready var login_container = $Panel/LoginContainer
@onready var panel = $Panel
@onready var background = $Background

const DesktopDev = "res://src/Ui/Pc/DesktopDev.tscn"

enum allowed_desktops {Developer,Player}

var  allowed_cresedentials:Dictionary = {
	"Master172":"Sumant1234$"
}

var desktops :Dictionary = {
	"Master172":allowed_desktops.Developer
}

var desktop = NAN

var Desktop = null
# Called when the node enters the scene tree for the first time.
func _ready():
	error.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visibility_toggled(button_pressed):
	password.secret = not password.secret


func _on_button_pressed():
	if username.text == "" or password.text == "":
		error.text = "Error:Please fill out the necessary fields"
		error.visible = true
	else:
		var err = validate_cresedentials(username.text,password.text)
		
		
		
		if err == 1 or err == 2:
			error.text = "Error:invalid cresedentials"
			error.visible = true
		
		elif err == 0:
			error.visible = false
			desktop = set_desktop(username.text)
			
func validate_cresedentials(username:String,password:String):
	if !allowed_cresedentials.has(username):
		return 1
		
	if allowed_cresedentials[username] != password:
		return 2
	
	if allowed_cresedentials[username] == password:
		return 0

func set_desktop(username):
	desktop = desktops[username]
	add_desktop()
	
func add_desktop():
	if desktop == allowed_desktops.Developer:
		Desktop = load(DesktopDev).instantiate()
		panel.visible = false
		background.visible = false
		add_child(Desktop)
		Desktop.connect("logout",_logout)
		
func _logout():
	if Desktop != null:
		Desktop.queue_free()
		panel.visible = true
		background.visible = true
		Desktop = null
