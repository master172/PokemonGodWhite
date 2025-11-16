extends Control

enum states {
	ROOM_SETUP,
	ROOM_ENTRY,
	TRADING,
	WAITING
}

@onready var trade_relay: Trade_Relay = $TradeRelay
@onready var waiting_room: Control = $WaitingRoom
@onready var v_box_container: VBoxContainer = $RoomSetup/Option/VBoxContainer
@onready var line_edit: LineEdit = $RoomEntry/Panel/VBoxContainer/LineEdit
@onready var room_setup: Control = $RoomSetup
@onready var room_entry: Control = $RoomEntry
@onready var trade_room: Control = $TradeRoom

var current_state:int = states.ROOM_SETUP

var max_selected:int = 2
var current_selected:int = 0

var selected_color:Color=Color(0.0, 0.848, 0.0, 1.0)
var deselcted_color:Color=Color(1.0, 1.0, 1.0, 1.0)

func set_room_button_active():
	v_box_container.get_child(current_selected).self_modulate = selected_color

func set_room_button_inactive():
	v_box_container.get_child(current_selected).self_modulate = deselcted_color

func connect_signals()->void:
	TradeManager.room_created.connect(_room_created)
	TradeManager.room_joined.connect(_room_joined)
	TradeManager.join_failed.connect(_join_failed)
	TradeManager.partner_disconnected.connect(_partner_disconnected)
	TradeManager.trade_message.connect(_handle_trade_message)
	
func _ready() -> void:
	connect_signals()
	set_room_button_active()
	room_entry.visible = false
	waiting_room.visible = false
	trade_room.visible = false
	room_setup.visible = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("W"):
		
		if current_state == states.ROOM_SETUP:
			AudioManager.input()
			set_room_button_inactive()
			current_selected = (current_selected + 1) % max_selected
			set_room_button_active()
	elif event.is_action_pressed("S"):
		
		if current_state == states.ROOM_SETUP:
			AudioManager.input()
			set_room_button_inactive()
			current_selected = (current_selected + max_selected - 1) % max_selected
			set_room_button_active()
	elif event.is_action_pressed("Yes"):
		
		if current_state == states.ROOM_SETUP:
			AudioManager.select()
			if current_selected == 0:
				trade_relay.send_create_room_request()
				
			elif current_selected == 1:
				room_entry.visible=true
				current_state = states.ROOM_ENTRY
				await get_tree().create_timer(0.1).timeout
				line_edit.grab_focus()

func _room_created(code:String):
	current_state = states.WAITING
	current_selected = 0
	waiting_room.visible = true
	waiting_room.display(code)

func _room_joined(code:String):
	room_setup.visible = false
	current_state = states.TRADING
	waiting_room.visible = false
	trade_room.visible = true
	trade_room.set_code(code)

func _join_failed(reason:String):
	OS.alert(reason)
	current_state = states.ROOM_SETUP

func _partner_disconnected():
	OS.alert("partner disconnected")

func _handle_trade_message(msg:Dictionary):
	trade_room.handle_trade_message(msg)
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	AudioManager.select()
	trade_relay.send_join_room_request(new_text)
	room_entry.visible = false
