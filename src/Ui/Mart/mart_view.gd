extends Control


@onready var noi = $Noi
@onready var item_list = $VBoxContainer/AllContainer/MainView/ScrollContainer/ItemList
@onready var scroll_container = $VBoxContainer/AllContainer/MainView/ScrollContainer

const item_tab = preload("res://src/Ui/Mart/item.tscn")
var current_selected:int = 0
var max_selected:int = 0

enum STATES {
	NORMAL,
	ITEMS
}

var state = STATES.NORMAL

var itemkey:int = 0
var countkey:int = 0

var items:Array[BaseItem]
var item_selected:BaseItem = null


func start_display_items():
	for i in item_list.get_children():
		i.queue_free()
	for i in items:
		var tab = item_tab.instantiate()
		tab.item = i
		item_list.add_child(tab)
		tab._prepare()
	
	await get_tree().create_timer(0.1).timeout
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
			
			item_selected.count = current_selected
	elif event.is_action_pressed("W"):
		if state == STATES.NORMAL:
			_unset()
			current_selected  = (current_selected +max_selected - 1) % max_selected
			_reset()
			_scrollUp()
			
		elif state == STATES.ITEMS:
			current_selected  = (current_selected + 1) % max_selected
			noi.set_values(current_selected,200)
			
			item_selected.count = current_selected
	elif event.is_action_pressed("Yes"):
		AudioManager.select()
		if state == STATES.NORMAL:
			state = STATES.ITEMS
			item_selected = item_list.get_child(current_selected).item
			itemkey = current_selected
			current_selected = 0
			noi.show()
			noi.set_values(1,item_selected.price)
			max_selected = 1000
		elif state == STATES.ITEMS:
			buy()
			state = STATES.NORMAL
			current_selected = itemkey
			itemkey = 0
			noi.hide()
			max_selected = item_list.get_child_count()
	elif event.is_action_pressed("No"):
		AudioManager.cancel()
		if state == STATES.NORMAL:
	
			queue_free()
			if Utils.get_player() != null:
				Utils.get_player().set_physics_process(true)
		elif state == STATES.ITEMS:
			state = STATES.NORMAL
			current_selected = itemkey
			itemkey = 0
			noi.hide()
			max_selected = item_list.get_child_count()

func buy():
	item_selected.pick_up()
	item_selected = null
	
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
