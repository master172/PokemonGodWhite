extends Node
class_name Trade_Relay

const create_room_message:Dictionary = {"type":"create_room"}
const join_room_message:Dictionary = {"type":"join_room","code":""}
func send_create_room_request():
	TradeManager.send_message(create_room_message)

func send_join_room_request(code:String):
	var new_join_room_messgae:Dictionary = join_room_message.duplicate()
	new_join_room_messgae["code"] = code
	TradeManager.send_message(new_join_room_messgae)
