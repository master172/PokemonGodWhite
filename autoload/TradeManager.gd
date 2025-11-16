extends Node

# The URL we will connect to.
# Use "ws://localhost:9080" if testing with the minimal server example below.
# `wss://` is used for secure connections,
# while `ws://` is used for plain text (insecure) connections.
@export var websocket_url = "wss://trademanagergoserver.onrender.com/ws"

# Our WebSocketClient instance.
var socket :WebSocketPeer

signal room_created(room_code:String)
signal room_joined(code:String)
signal join_failed(reason:String)
signal partner_disconnected
signal trade_message(messgae:Dictionary)

var connected_to_server :bool = false

func _ready() -> void:
	set_process(false)
	
func connect_to_server():
	if connected_to_server:
		return
	
	socket = WebSocketPeer.new()
	
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		push_error("Failed to connect via Websocket")
		return
	set_process(true)
	connected_to_server = true

func disconnect_from_server():
	if not connected_to_server:
		return
	
	socket.close(1000,"Client closed connection")
	connected_to_server = false
	set_process(false)
	
func _process(_delta):
	# Call this in `_process()` or `_physics_process()`.
	# Data transfer and state updates will only happen when calling this function.
	socket.poll()

	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# `WebSocketPeer.STATE_OPEN` means the socket is connected and ready
	# to send and receive data.
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				var data = JSON.parse_string(packet_text)
				if typeof(data) == TYPE_DICTIONARY:
					handle_recived_messages(data)
				

	# `WebSocketPeer.STATE_CLOSING` means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# `WebSocketPeer.STATE_CLOSED` means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be `-1` if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.

func handle_recived_messages(msg:Dictionary)->void:
	var type:String = msg["type"]
	match type:
		"room_created":
			room_created.emit(msg["code"])
		"paired":
			room_joined.emit(msg["code"])
		"join_failed":
			join_failed.emit(msg["reason"])
		"partner_disconnected":
			partner_disconnected.emit()
		"trade_message":
			trade_message.emit(msg)

func send_message(msg:Dictionary):
	socket.send_text(JSON.stringify(msg))
