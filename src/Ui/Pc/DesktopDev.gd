extends Control

@onready var panel = $Panel

var matches = []

@onready var items = $Panel/ScrollContainer/items.get_children()
@onready var time = $Background/TopBar/HBoxContainer/Time
@onready var date = $Background/TopBar/HBoxContainer/Date
@onready var month = $Background/TopBar/HBoxContainer/Month
@onready var weekday = $Background/TopBar/HBoxContainer/Weekday
@onready var start_menu = $StartMenu
@onready var line_edit = $Background/ToolBar/HBoxContainer/LineEdit

var Month:Array =[
	"January",
	"February",
	"March",
	"April",
	"May",
	"June",
	"July",
	"August",
	"September",
	"October",
	"November",
	"December"
	]

var Weekday:Array = [
	"Sunday",
	"Monday",
	"Tuesday",
	"Thrusday",
	"Friday",
	"Saturday",
	"Sunday"
	]

signal logout
signal poweroff
signal restart

# Called when the node enters the scene tree for the first time.

func _ready():
	panel.hide()
	start_menu.hide()
	month.text = Month[get_month()]
	weekday.text = Weekday[get_weekday()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time.text = get_time()
	date.text = get_date()

func _on_line_edit_text_changed(new_text):
	
	new_text = new_text.to_lower()
	if new_text == "":
		for i in items:
			i.show()
		return
	matches.clear()
	
	
	for i in items:
		if new_text in i.text.to_lower():
			matches.append(i)
	for i in items:
		if i in matches:
			i.show()
		else:
			i.hide()


func _on_line_edit_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			panel.show()
			start_menu.hide()
			panel.grab_focus()

func _on_background_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			panel.hide()
			start_menu.hide()
			panel.release_focus()
			line_edit.text = ""
			_on_line_edit_text_changed(line_edit.text)
	
func get_time():
	var current_time = Time.get_time_string_from_system()
	return current_time

func get_date():
	var date = Time.get_date_string_from_system()
	return date

func get_weekday():
	var datetime= Time.get_datetime_dict_from_system()
	var weekday = datetime["weekday"]
	return weekday

func get_month():
	var datetime = Time.get_datetime_dict_from_system()
	var month = datetime["month"]
	return month


func _on_main_pressed():
	start_menu.show()
	panel.hide()
	panel.release_focus()


func _on_logout_pressed():
	emit_signal("logout")
