extends Control


@onready var noi = $Noi
@onready var item_list = $VBoxContainer/AllContainer/MainView/ScrollContainer/ItemList
@onready var scroll_container = $VBoxContainer/AllContainer/MainView/ScrollContainer

var current_selected:int = 0
var max_selected:int = 0

enum STATES {
	NORMAL,
	ITEMS
}

var state = STATES.NORMAL

var itemkey:int = 0
var countkey:int = 0

func _ready():
	max_selected = item_list.get_child_count()
	item_list.get_child(current_selected)._active()

func _unset():
	item_list.get_child(current_selected)._unactive()

func _reset():
	item_list.get_child(current_selected)._active()
	
func _input(event):
	if event.is_action_pressed("S"):
		if state == STATES.NORMAL:
			_unset()
			current_selected  = (current_selected + 1) % max_selected
			_reset()
			_scrollDown()
			
		elif state == STATES.ITEMS:
			current_selected  = (current_selected +max_selected - 1) % max_selected
			noi.set_values(current_selected,200)
			
	elif event.is_action_pressed("W"):
		if state == STATES.NORMAL:
			_unset()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			_reset()
			_scrollUp()
			
		elif state == STATES.ITEMS:
			current_selected  = (current_selected + 1) % max_selected
			noi.set_values(current_selected,200)
			
	elif event.is_action_pressed("Yes"):
		if state == STATES.NORMAL:
			state = STATES.ITEMS
			itemkey = current_selected
			current_selected = 0
			noi.show()
			noi.set_values(1,200)
			max_selected = 1000
		elif state == STATES.ITEMS:
			state = STATES.NORMAL
			current_selected = itemkey
			itemkey = 0
			noi.hide()

func _scrollDown():
	if current_selected >= 7:
		scroll_container.scroll_vertical += 73
	else:
		scroll_container.scroll_vertical = 0
	

func _scrollUp():
	if current_selected < max_selected-1:
		scroll_container.scroll_vertical -= 73
	elif current_selected == max_selected-1:
		scroll_container.scroll_vertical = current_selected*73
