extends Control

@onready var line_edit: LineEdit = $VBoxContainer/HBoxContainer/Control/VBoxContainer/LineEdit
@onready var code_label: Label = $VBoxContainer/Panel/CodeLabel
@onready var rich_text_label: RichTextLabel = $VBoxContainer/HBoxContainer/Control/VBoxContainer/RichTextLabel
@onready var selector: Control = $VBoxContainer/HBoxContainer/Selector
@onready var confirm: Panel = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/Confirm
@onready var lock: Panel = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/Lock

@onready var offered_sprite: TextureRect = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/Inner/TextureRect2
@onready var offered_name: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/Name
@onready var offered_level: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/Level
@onready var offered_item: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel2/VBoxContainer/Item

@onready var my_sprite: TextureRect = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/Inner/TextureRect
@onready var my_name: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/Name
@onready var my_level: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/Level
@onready var my_item: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/VBoxContainer/HBoxContainer/Panel/VBoxContainer/Item
@onready var trade_relay: Monster_Trader = $Trade_Relay
@onready var confirmation: Control = $Confirmation
@onready var trade_finisher: TradeFinisher = $TradeFinisher

var code:String = ""
var selected_pokemon:int = 0

enum states {
	INACTIVE,
	CHAT,
	MAIN,
	SELECTION,
	CONFIRMATION,
	TRADING,
}

var current_selected:int = 0
var max_selected:int = 2
var current_state:int = states.INACTIVE

var selected_color:Color=Color(0.0, 0.848, 0.0, 1.0)
var deselcted_color:Color=Color(1.0, 1.0, 1.0, 1.0)

@onready var option_list:Array[Panel] = [lock,confirm]

signal closed

#region tradevariables
var offered_pokemon_num:int = -1
var offered_pokemon:game_pokemon
var locked_in:bool = false
var partner_locked_in:bool = false
var confirmed:bool = false
var partner_confirmed:bool = false
#endregion

func set_code(code_:String):
	code = code_
	code_label.text = "Room Code: "+code
	selector.start()
	current_state = states.SELECTION

func handle_trade_message(msg:Dictionary):
	var type:String = msg["msg_type"]
	if type == "chat":
		add_other_message(msg["msg"])
	elif type == "offer":
		locked_in = false
		partner_locked_in = false
		set_offered_pokemon(msg["path"],msg["level"],msg["item"],msg["name"])
	elif type == "lock_in":
		recieve_lock_in()
	elif type == "reject":
		manage_rejections()
	elif type == "cancel":
		manage_cancellation()
	elif type == "confirm":
		manage_confirmation()
	elif type == "send":
		send_pokemon_file()
	elif type == "trade":
		handle_file_recived(msg["data"])
		
#region Chat
func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if new_text == "":
		return
	var trade_message:Dictionary = {
		"type":"trade_message",
		"msg_type":"chat",
		"msg":new_text
	}
	TradeManager.send_message(trade_message)
	add_self_message(new_text)
	line_edit.text = ""
	line_edit.grab_focus()
	
func add_other_message(msg:String):
	var text = "\n[color=#c770ff][b]Partner:[/b][/color] "
	rich_text_label.append_text(text+ timestamp() + " "+escape(msg))
	_scroll()
	
func add_self_message(msg:String):
	var text = "\n[color=#57e3c1][b]You:[/b][/color] "
	rich_text_label.append_text(text+ timestamp() + " "+ escape(msg))
	_scroll()
	
func _scroll():
	await get_tree().process_frame
	rich_text_label.scroll_to_line(rich_text_label.get_line_count() - 1)

func escape(text:String) -> String:
	return text

func timestamp() -> String:
	return "[color=gray]" + Time.get_time_string_from_system().substr(0,5) + "[/color]"
#endregion

#region Ui
func set_offered_pokemon(path:String,level:String,item:String,nick_name:String):
	
	var pokemon:Pokemon = load(path)
	offered_sprite.texture = pokemon.get_front_sprite()
	offered_name.text = nick_name
	offered_level.text = "Level: "+level
	offered_item.text = "Item: "+item

func set_my_pokemon(poke:int):
	var pokemon:game_pokemon = AllyPokemon.get_party_pokemon(poke)
	my_name.text = pokemon.Nick_name
	my_sprite.texture = pokemon.get_front_sprite()
	my_level.text = "Level: "+str(pokemon.level)
	my_item.text = "Item: "+pokemon.held_item.Name if pokemon.held_item != null else "Item: "

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("D"):
		if current_state == states.SELECTION:
			AudioManager.input()
			selector.stop()
			current_state = states.MAIN
			option_list[current_selected].self_modulate = selected_color
		elif current_state == states.MAIN:
			AudioManager.input()
			option_list[current_selected].self_modulate = deselcted_color
			current_state = states.CHAT
			await get_tree().create_timer(0.1).timeout
			line_edit.grab_focus()
	elif event.is_action_pressed("A"):
		
		if current_state == states.CHAT and line_edit.is_editing() == false:
			AudioManager.input()
			current_state = states.MAIN
			option_list[current_selected].self_modulate = selected_color
			line_edit.release_focus()
		elif current_state == states.MAIN:
			AudioManager.input()
			option_list[current_selected].self_modulate = deselcted_color
			current_state = states.SELECTION
			selector.start()
	elif event.is_action_pressed("W"):
		if current_state == states.MAIN:
			AudioManager.input()
			option_list[current_selected].self_modulate = deselcted_color
			current_selected = (current_selected + max_selected -1 ) % max_selected
			option_list[current_selected].self_modulate = selected_color
	elif event.is_action_pressed("S"):
		if current_state == states.MAIN:
			AudioManager.input()
			option_list[current_selected].self_modulate = deselcted_color
			current_selected = (current_selected + 1 ) % max_selected
			option_list[current_selected].self_modulate = selected_color
	elif event.is_action_pressed("Yes"):
		if current_state == states.MAIN:
			if current_selected == 0:
				AudioManager.select()
				manage_sending_lockins()
			elif current_selected == 1:
				AudioManager.cancel()
				send_rejections()
				
	elif event.is_action_pressed("No"):
		if line_edit.is_editing() == false:
			current_state = states.INACTIVE
			closed.emit()
#endregion

func manage_sending_lockins():
	add_self_message("[color=#dedb00ff]Locked in the trade[/color]")
	locked_in = true
	trade_relay.send_lock_in()
	if partner_locked_in == true and locked_in == true:
		move_to_confirmation()
	
func recieve_lock_in():
	partner_locked_in = true
	add_other_message("[color=#dedb00ff]Locked in the trade[/color]")
	if partner_locked_in == true and locked_in == true:
		move_to_confirmation()

func move_to_confirmation():
	current_state = states.CONFIRMATION
	confirmation.activate()
	
func send_rejections():
	add_self_message("[color=#ff0000ff]You rejected the offer[/color]")
	locked_in = false
	trade_relay.send_rejection()
	
func manage_rejections():
	add_other_message("[color=#ff0000ff]Rejected your offer[/color]")
	partner_locked_in = false
	


func _on_selector_select(num: int) -> void:
	selected_pokemon = num
	offered_pokemon = AllyPokemon.get_party_pokemon(num)
	offered_pokemon_num = num
	set_my_pokemon(num)
	trade_relay.send_offer(num)
	locked_in = false
	partner_locked_in = false


func _on_confirmation_cancel_trade() -> void:
	locked_in = false
	partner_locked_in = false
	trade_relay.send_cancellation()
	await get_tree().create_timer(0.1).timeout
	current_state = states.MAIN

func _on_confirmation_confirm_trade() -> void:
	confirmed = true
	trade_relay.send_confirmation()
	if partner_confirmed == true and confirmed == true:
		start_trading()

func manage_cancellation():
	locked_in = false
	partner_locked_in = false
	await get_tree().create_timer(0.1).timeout
	current_state = states.MAIN
	confirmation.deactivate()

func manage_confirmation():
	partner_confirmed = true
	if confirmed == true and partner_confirmed == true:
		start_trading()

func start_trading():
	if partner_confirmed == true and confirmed == true:
		print_debug("sending pokemon "+offered_pokemon.Nick_name)
		send_pokemon_file()
	
func handle_file_recived(buffer:String):
	var pokemon:game_pokemon = trade_finisher.receive_resource_file(buffer)
	AllyPokemon.trade_pokemon(offered_pokemon_num,pokemon)
	offered_pokemon_num = -1
	offered_pokemon = null
	postset()

func postset():
	locked_in = false
	partner_locked_in = false
	confirmed = false
	partner_confirmed = false
	trade_finisher.remove_directires()
	update_images()
	offered_pokemon = null
	offered_pokemon_num = -1
	current_state = states.MAIN
	
func send_pokemon_file():
	current_state = states.TRADING
	trade_relay.send_pokemon_file(offered_pokemon_num)

func update_images():
	my_item.text = ""
	my_level.text = ""
	my_name.text = ""
	my_sprite.texture = null
	offered_item.text = ""
	offered_level.text = ""
	offered_name.text = ""
	offered_sprite.texture = null
	selector.update()
