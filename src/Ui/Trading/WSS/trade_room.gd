extends Control

@onready var line_edit: LineEdit = $VBoxContainer/HBoxContainer/Control/VBoxContainer/LineEdit
@onready var code_label: Label = $VBoxContainer/Panel/CodeLabel
@onready var rich_text_label: RichTextLabel = $VBoxContainer/HBoxContainer/Control/VBoxContainer/RichTextLabel

var code:String = ""

func set_code(code_:String):
	code = code_
	code_label.text = "Room Code: "+code
	line_edit.grab_focus()

func handle_trade_message(msg:Dictionary):
	var type:String = msg["msg_type"]
	if type == "chat":
		add_other_message(msg["msg"])
		
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
