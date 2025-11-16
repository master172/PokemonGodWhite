extends Control

enum states {
	ROOM_SETUP,
	ROOM_ENTRY,
	TRADING,
	WAITING,
	AWAITING,
	MESSAGE
}

@onready var trade_relay: Trade_Relay = $TradeRelay
@onready var waiting_room: Control = $WaitingRoom
@onready var v_box_container: VBoxContainer = $RoomSetup/Option/VBoxContainer
@onready var line_edit: LineEdit = $RoomEntry/Panel/VBoxContainer/LineEdit
@onready var room_setup: Control = $RoomSetup
@onready var room_entry: Control = $RoomEntry
@onready var trade_room: Control = $TradeRoom
@onready var message_box: Control = $MessageBox

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
				TradeManager.connect_to_server()
				current_state = states.AWAITING
				await get_tree().create_timer(2).timeout
				trade_relay.send_create_room_request()
				
			elif current_selected == 1:
				TradeManager.connect_to_server()
				current_state = states.AWAITING
				await get_tree().create_timer(2).timeout
				room_entry.visible=true
				current_state = states.ROOM_ENTRY
				await get_tree().create_timer(0.1).timeout
				line_edit.grab_focus()
	elif event.is_action_pressed("No"):
		if current_state == states.ROOM_SETUP:
			AudioManager.cancel()
			queue_free()
		elif current_state == states.WAITING:
			TradeManager.disconnect_from_server()
			waiting_room.visible = false
			current_state = states.ROOM_SETUP
		elif current_state == states.ROOM_ENTRY and line_edit.is_editing() == false:
			AudioManager.cancel()
			room_entry.visible = false
			line_edit.text = ""
			current_state =states.ROOM_SETUP
			
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
	current_state = states.MESSAGE
	trade_room.set_state_to_message()
	message_box.set_title("Client disconnected")
	message_box.set_message("The trading scene will be closed now")
	message_box.display()

func _handle_trade_message(msg:Dictionary):
	trade_room.handle_trade_message(msg)
	
func _on_line_edit_text_submitted(new_text: String) -> void:
	AudioManager.select()
	trade_relay.send_join_room_request(new_text)
	room_entry.visible = false


func _on_trade_room_closed() -> void:
	AudioManager.cancel()
	TradeManager.disconnect_from_server()
	trade_room.visible = false
	room_setup.visible = true
	await get_tree().create_timer(0.1).timeout
	current_state = states.ROOM_SETUP


func _on_message_box_message_closed() -> void:
	TradeManager.disconnect_from_server()
	queue_free()
