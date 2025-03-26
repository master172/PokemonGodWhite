extends Node

# Multiplayer variables
var PORT: int = 7000
var MAX_CONNECTIONS: int = 1
var connection_server_ip: String = "127.0.0.1"
var connected_player_id: int
var self_id: int = 1

# Trade data
var pokemon: game_pokemon
var traded_pokemon: game_pokemon
var offered_pokemon: Pokemon
var set_pokemon_index: int = 0

var offer_set := false
var trader_offer_set := false
var self_accepted := false
var trader_accepted := false

# Paths
var save_file_path := "user://Trade/"
var save_file_name := "Pokemon.tres"
var path_to_temp := "user://Temp/"
var temp_file_name := "tradedpokemon.tres"

# Signals
signal player_connected(peer_id)
signal player_disconnected(peer_id)
signal server_disconnected
signal received_pokemon
signal trade_accepted
signal offer_denied
signal offer_made(pokemon:Pokemon,level:int)
signal trade_fullfilled(pokemon:game_pokemon)

func _ready():
	multiplayer_setup()

func multiplayer_setup():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

# Server and Client Logic
func create_game(port:int = PORT):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, MAX_CONNECTIONS)
	if error != OK: return error
	multiplayer.multiplayer_peer = peer
	self_id = 1
	return OK

func join_game(port:int = PORT,address :String= "127.0.0.1"):
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error != OK: return error
	multiplayer.multiplayer_peer = peer
	return OK

func disconnect_network():
	if multiplayer.multiplayer_peer:
		multiplayer.multiplayer_peer.close()
		multiplayer.multiplayer_peer = null

# Callbacks
func _on_peer_connected(id): connected_player_id = id; emit_signal("player_connected", id)
func _on_player_disconnected(id): emit_signal("player_disconnected", id)
func _on_connected_ok(): pass
func _on_connected_fail(): multiplayer.multiplayer_peer = null
func _on_server_disconnected(): multiplayer.multiplayer_peer = null; emit_signal("server_disconnected")

# Offer and Trade Logic
func offer_pokemon(poke: game_pokemon):
	pokemon = poke
	offer_set = true
	_send_offered_pokemon()

func _send_offered_pokemon():
	var path = pokemon.Base_Pokemon.get_path()
	var target = connected_player_id if multiplayer.is_server() else 1
	recive_offered_pokemon.rpc_id(target, path, pokemon.level)

@rpc("any_peer")
func recive_offered_pokemon(path, lv: int):
	trader_offer_set = true
	var poke: Pokemon = load(path)
	offered_pokemon = poke
	emit_signal("offer_made",poke,lv)

func accept_trade():
	self_accepted = true
	var target = connected_player_id if multiplayer.is_server() else 1
	confirm_accept_request.rpc_id(target)

@rpc("any_peer")
func confirm_accept_request():
	trader_accepted = true
	emit_signal("trade_accepted")

func validate_trade():
	if offer_set and trader_offer_set and self_accepted and trader_accepted:
		export_and_send()
		ask_to_receive_pokemon()
		request_update()
		request_for_request_update()

func ask_to_receive_pokemon():
	var target = connected_player_id if multiplayer.is_server() else 1
	export_and_send.rpc_id(target)

@rpc("any_peer")
func export_and_send():
	DirAccess.make_dir_recursive_absolute(save_file_path)
	ResourceSaver.save(pokemon, save_file_path + save_file_name)
	var bytes = FileAccess.get_file_as_bytes(save_file_path + save_file_name)
	var target = connected_player_id if multiplayer.is_server() else 1
	receive_resource_file.rpc_id(target, bytes)

@rpc("any_peer")
func receive_resource_file(bytes):
	DirAccess.make_dir_recursive_absolute(path_to_temp)
	var file = FileAccess.open(path_to_temp + temp_file_name, FileAccess.WRITE)
	file.store_buffer(bytes)
	file.close()
	traded_pokemon = ResourceLoader.load(path_to_temp + temp_file_name)
	emit_signal("received_pokemon", traded_pokemon)
	print(traded_pokemon.Nick_name)
	
func reject_trade():
	var target = connected_player_id if multiplayer.is_server() else 1
	request_denied.rpc_id(target)

@rpc("any_peer")
func request_denied():
	offer_set = false
	emit_signal("offer_denied")

@rpc("any_peer")
func set_pokemons():
	if traded_pokemon != null:
		var temp = pokemon
		pokemon = traded_pokemon
		traded_pokemon = temp
		remove_directires()
		Ally_postset()
		reset_trade_values()
		emit_signal("trade_fullfilled",traded_pokemon)
		print("reached here")
		
func Ally_postset():
	AllyPokemon.trade_pokemon(set_pokemon_index,pokemon)

func reset_trade_values():
	offer_set = false
	trader_offer_set = false
	self_accepted = false
	trader_accepted = false
	
func remove_directires():
	if DirAccess.dir_exists_absolute("user://Trade/"):
		var dir = DirAccess.open("user://Trade/")
		var files = dir.get_files()
		for file in files:
			dir.remove(file)
		dir.remove("user://Trade/")
		
	if DirAccess.dir_exists_absolute("user://Temp/"):
		var dir = DirAccess.open("user://Temp/")
		var files = dir.get_files()
		for file in files:
			dir.remove(file)
		dir.remove("user://Temp/")

@rpc("any_peer")
func request_update():
	if multiplayer.is_server():
		set_pokemons.rpc_id(connected_player_id)
	else:
		set_pokemons.rpc_id(1)

func request_for_request_update():
	if multiplayer.is_server():
		request_update.rpc_id(connected_player_id)
	else:
		request_update.rpc_id(1)
