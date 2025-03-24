extends Control

##Multiplayer Stuff
var PORT = 7000
var DEFAULT_SERVER_IP = "127.0.0.1"
const MAX_CONNECTIONS = 1

signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal server_disconnected
signal recived_pokemon

@onready var my_poke: TextureRect = $VBoxContainer/SpriteHolder/MyPoke
@onready var other_poke: TextureRect = $VBoxContainer/SpriteHolder/OtherPoke
@onready var label: Label = $VBoxContainer/Label

var offered_pokemon:Pokemon

@export var pokemon:game_pokemon:
	set(value):
		pokemon = value
		my_poke.texture = pokemon.Base_Pokemon.get_front_sprite()
var traded_pokemon:game_pokemon:
	set(value):
		traded_pokemon = value
		other_poke.texture = pokemon.Base_Pokemon.get_front_sprite()

var set_pokemon_index:int = 0

var connected_player_id:int
var self_id:int = 1


var offer_set:bool = false
var trader_offer_set:bool = false
var self_accepeted:bool = false
var trader_accepeted:bool = false

##saving variables
var save_file_path = "user://Trade/"
var save_file_name = "Pokemon.tres"
var path_to_temp = "user://Temp/"
var temp_file_name = "tradedpokemon.tres"

func _ready() -> void:
	pokemon = AllyPokemon.get_main_pokemon()
	set_pokemon_index = 0
	multiplayer_setup()
	verify_save_directory(save_file_path)
	
#region Multiplayer_Setup
func multiplayer_setup():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
func _on_peer_connected(id):
	print("peer connected ",id)
	label.text = "connection made with"
	var new_player_id = multiplayer.get_remote_sender_id()
	connected_player_id = new_player_id

func _on_player_disconnected(id):
	connected_player_id = NAN
	player_disconnected.emit(id)


func _on_connected_ok():
	var peer_id = multiplayer.get_unique_id()


func _on_connected_fail():
	multiplayer.multiplayer_peer = null


func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	connected_player_id = NAN
	server_disconnected.emit()
	
func create_game():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()  # Optional but clean
		multiplayer.multiplayer_peer = null
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	self_id = 1

func join_game(address = ""):
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null
	if address.is_empty():
		address = DEFAULT_SERVER_IP
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
#endregion

func _on_create_host_pressed() -> void:
	create_game()

func _on_connect_pressed() -> void:
	join_game()

#region Saving
func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
#endregion

func _on_trade_pressed() -> void:
	self_accepeted = true
	send_accept_reqest()
	validate_trade()
	#export_and_send()

func _on_poke_selector_poke_changed(poke: game_pokemon,num:int) -> void:
	pokemon = poke
	set_pokemon_index = num

func _on_offer_pressed() -> void:
	send_offered_pokemon()
	
func send_offered_pokemon():
	offer_set = true
	var path:String = pokemon.Base_Pokemon.get_path()
	if multiplayer.is_server():
		recive_offered_pokemon.rpc_id(connected_player_id,path)
	else:
		recive_offered_pokemon.rpc_id(1,path)


@rpc("any_peer")

func recive_offered_pokemon(path):
	trader_offer_set = true
	var poke:Pokemon = load(path)
	other_poke.texture = poke.get_front_sprite()
	offered_pokemon = poke

func send_accept_reqest():
	if multiplayer.is_server():
		confirm_accept_request.rpc_id(connected_player_id)
	else:
		confirm_accept_request.rpc_id(1)

@rpc("any_peer")
func confirm_accept_request():
	trader_accepeted = true
	label.text = "trade accepted"

func ask_to_recive_pokemon():
	if multiplayer.is_server():
		export_and_send.rpc_id(connected_player_id)
	else:
		export_and_send.rpc_id(1)

@rpc("any_peer")
func export_and_send():
	verify_save_directory(save_file_path)
	ResourceSaver.save(pokemon, save_file_path+save_file_name)
	var bytes = FileAccess.get_file_as_bytes(save_file_path+save_file_name)
	if multiplayer.is_server():
		receive_resource_file.rpc_id(connected_player_id,bytes)
	else:
		receive_resource_file.rpc_id(1,bytes)

@rpc("any_peer")

func receive_resource_file(bytes):
	verify_save_directory(path_to_temp)
	var file = FileAccess.open(path_to_temp+temp_file_name, FileAccess.WRITE)
	file.store_buffer(bytes)
	file.close()
	var monster = ResourceLoader.load(path_to_temp+temp_file_name)
	traded_pokemon = monster
	label.text = ("Received monster: "+ traded_pokemon.Nick_name)


func request_for_request_update():
	if multiplayer.is_server():
		request_update.rpc_id(connected_player_id)
	else:
		request_update.rpc_id(1)

@rpc("any_peer")
func request_update():
	if multiplayer.is_server():
		set_pokemons.rpc_id(connected_player_id)
	else:
		set_pokemons.rpc_id(1)

@rpc("any_peer")
func set_pokemons():
	if traded_pokemon != null:
		var temp = pokemon
		pokemon = traded_pokemon
		traded_pokemon = temp
		remove_directires()
		AllyPokemon.set_pokemon(set_pokemon_index,pokemon.duplicate())
		
func validate_trade():
	if not (offer_set == true and trader_offer_set == true):
		label.text = "offers not made"
		return
	if not (self_accepeted == true and trader_accepeted == true):
		label.text = "trade not finalized"
		return
	export_and_send()
	ask_to_recive_pokemon()
	request_update()
	request_for_request_update()
	
func _on_reject_pressed() -> void:
	if trader_accepeted == false:
		send_rejection()

func send_rejection():
	if multiplayer.is_server():
		request_denied.rpc_id(connected_player_id)
	else:
		request_denied.rpc_id(1)
		
@rpc("any_peer")
func request_denied():
	label.text = "request denied"
	offer_set = false

func remove_directires():
	if DirAccess.dir_exists_absolute("user://Trade/"):
		var dir = DirAccess.open("user://Trade/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://Trade/")
		
	##deleting Trainer save files
	if DirAccess.dir_exists_absolute("user://Temp/"):
		var dir = DirAccess.open("user://Temp/")
		var files = dir.get_files()
		
		for file in files:
			dir.remove(file)
		dir.remove("user://Temp/")


func _on_port_value_changed(value: float) -> void:
	PORT = value


func _on_line_edit_text_submitted(new_text: String) -> void:
	DEFAULT_SERVER_IP = new_text

func disconnect_network():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()  # Gracefully close connection
		multiplayer.multiplayer_peer = null   # Reset the peer
		print("Disconnected from network.")


func _on_disconnect_pressed() -> void:
	disconnect_network()
	get_tree().change_scene_to_file("res://src/Main/main_menu.tscn")
