extends Trade_Relay
class_name Monster_Trader

@export var trade_finisher: TradeFinisher

func send_offer(pokemon:int):
	var offer :game_pokemon= AllyPokemon.get_party_pokemon(pokemon)
	var path :String = offer.Base_Pokemon.get_path()
	var level = str(offer.level)
	var item:String = offer.held_item.Name if offer.held_item != null else ""
	var nick_name:String = offer.Nick_name
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"offer",
		"path":path,
		"level":level,
		"item":item,
		"name":nick_name
	}
	TradeManager.send_message(message)

func send_lock_in():
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"lock_in"
	}
	TradeManager.send_message(message)

func send_rejection():
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"reject"
	}
	TradeManager.send_message(message)

func send_confirmation():
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"confirm"
	}
	TradeManager.send_message(message)

func send_cancellation():
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"cancel"
	}
	TradeManager.send_message(message)

func start_trading():
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"send"
	}
	TradeManager.send_message(message)

func send_pokemon_file(num:int):
	var pokemon:game_pokemon = AllyPokemon.get_party_pokemon(num).duplicate()
	var bytes :String = trade_finisher.export_pokemon(pokemon)
	var message:Dictionary = {
		"type":"trade_message",
		"msg_type":"trade",
		"data":bytes
	}
	
	TradeManager.send_message(message)
