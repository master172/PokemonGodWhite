extends Control

var connection_server_ip:String = "127.0.0.1"
var PORT:int = 7000

@onready var connection_screen: MarginContainer = $ConnectionScreen
@onready var trade_screen: Panel = $TradeScreen

@onready var my_poke: TextureRect = $TradeScreen/MarginContainer/VBoxContainer/ImageContainer/BackDrop/my_poke
@onready var other_poke: TextureRect = $TradeScreen/MarginContainer/VBoxContainer/ImageContainer/BackDrop2/other_poke
@onready var label: Label = $TradeScreen/MarginContainer/VBoxContainer/InfoLabel

@onready var lv_2: Label = $TradeScreen/MarginContainer/VBoxContainer/LabelContainer/Lv2
@onready var lv_1: Label = $TradeScreen/MarginContainer/VBoxContainer/LabelContainer/Lv1

@onready var selection_container: HBoxContainer = $TradeScreen/MarginContainer/VBoxContainer/SelectionContainer

@onready var connection_label: Label = $ConnectionScreen/VBoxContainer/Label


var selected_pokemon:game_pokemon:
	set(value):
		selected_pokemon = value
		my_poke.texture = selected_pokemon.Base_Pokemon.get_front_sprite()
var selected_pokemon_num:int = -1

var offered_pokemon:Pokemon:
	set(value):
		offered_pokemon = value
		other_poke.texture = offered_pokemon.get_front_sprite()
##sate variables
enum states {
	CONNECTION,
	TRADE
}
var current_state:states = states.CONNECTION

func _ready() -> void:
	TradeManager.connect("player_connected", Callable(self, "_on_player_connected"))
	TradeManager.connect("received_pokemon", Callable(self, "_on_pokemon_received"))
	TradeManager.connect("trade_accepted", Callable(self, "_on_trade_accepted"))
	TradeManager.connect("offer_denied", Callable(self, "_on_offer_denied"))
	TradeManager.connect("offer_made", Callable(self, "_on_offer_made"))
	TradeManager.connect("trade_fullfilled", Callable(self, "_on_trade_fullfilled"))
	update()

func update():
	if current_state == states.CONNECTION:
		trade_screen.visible = false
		connection_screen.visible = true
	elif current_state == states.TRADE:
		connection_screen.visible = false
		trade_screen.visible = true

func update_connection_label(str:String):
	connection_label.text = str

func _on_player_connected(_id:int):
	current_state = states.TRADE
	update()
	selection_container.update()
	
func _on_create_host_pressed() -> void:
	if current_state == states.CONNECTION:
		TradeManager.disconnect_network()
		var err = TradeManager.create_game(PORT)
		if err == OK:
			update_connection_label("hosting server on " + get_local_ip())
			print("Hosting trade server...")
		else:
			print("Failed to host server: ", err)
		
func _on_connect_pressed() -> void:
	if current_state == states.CONNECTION:
		TradeManager.disconnect_network()
		var err = TradeManager.join_game(PORT,connection_server_ip)
		if err == OK:
			print("Connecting to server...")
		else:
			print("Failed to connect: ", err)

func _on_trade_pressed() -> void:
	TradeManager.accept_trade()
	TradeManager.validate_trade()
	label.text = "waiting for trade confirmation"

func _on_offer_pressed() -> void:
	TradeManager.offer_pokemon(selected_pokemon,selected_pokemon_num)
	label.text = "offer sent"
	
func _on_reject_pressed() -> void:
	TradeManager.reject_trade()

func _on_port_value_changed(value: float) -> void:
	PORT = value

func _on_line_edit_text_submitted(new_text: String) -> void:
	connection_server_ip = new_text

func _on_disconnect_pressed() -> void:
	TradeManager.disconnect_network()
	current_state = states.CONNECTION
	update()
	
func _on_back_pressed() -> void:
	TradeManager.disconnect_network()
	TradeManager.remove_directires()
	queue_free()
	
func get_local_ip():
	var ips = IP.get_local_addresses()
	for ip in ips:
		if ip.begins_with("192.168.") or ip.begins_with("10.") or ip.begins_with("172."):
			return ip
	return "Unknown"

func _on_selection_container_poke_changed(poke: game_pokemon, num: int) -> void:
	selected_pokemon = poke
	lv_1.text = "level: " + str(selected_pokemon.level)
	selected_pokemon_num = num

func _on_trade_fullfilled(pokemon:game_pokemon):
	selection_container.update()
	offered_pokemon = pokemon.Base_Pokemon
	lv_2.text = str(pokemon.level)
	label.text = "trade fullfilled"
	
func _on_offer_made(pokemon:Pokemon,level:int):
	offered_pokemon = pokemon
	lv_2.text = str(level)

func _on_offer_denied():
	label.text = "trade request denied"

func _on_trade_accepted():
	label.text = "trade request accepted"

func _on_pokemon_received(pokemon:game_pokemon):
	selected_pokemon = pokemon
	lv_1.text = str(selected_pokemon.level)
	
