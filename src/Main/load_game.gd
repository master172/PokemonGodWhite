extends Control

@onready var slot_container: VBoxContainer = $MarginContainer/MainContainer/ScrollContainer/SlotContainer
@onready var scroll_container: ScrollContainer = $MarginContainer/MainContainer/ScrollContainer

const LOAD_PANEL = preload("res://src/Main/LoadPanel.tscn")

var max_range:int = 0

var active:bool = false:
	set(value):
		active = value
		visible = active

func _ready() -> void:
	visible = active
	#Global.slots_loaded.connect(add_nodes)
	add_nodes()
	
func add_nodes():
	max_range = Global.slot_dict.keys().size()
	for i in max_range:
		var slot = LOAD_PANEL.instantiate()
		slot_container.add_child(slot)
		slot.slot_index = i
		
func unset_selected(num:int):
	slot_container.get_child(num).active = false

func set_selected(num:int):
	slot_container.get_child(num).active = true

func delete_slot(num:int):
	var node_to_free = slot_container.get_child(num)
	node_to_free.queue_free()
	await node_to_free.tree_exited
	scroll(num-1)
	set_selected(num-1)
	reset_info()
	
func reset_info():
	for i in range(0,slot_container.get_child_count()):
		slot_container.get_child(i).slot_index = i

func scroll(num:int):
	scroll_container.scroll_vertical = clamp((num-4)*142,0,max_range*142)
