extends Control

var expression = Expression.new()
@onready var line_edit: LineEdit = $VBoxContainer/LineEdit

@onready var rich_text_label: RichTextLabel = $VBoxContainer/RichTextLabel
@onready var commands: Node = $commands
@onready var suggestions: Label = $suggestions

var input_commands :Array = []

var history:Array[String] = []
var current_history_index:int = -1
const MAX_HISTORY_SIZE:int = 20

func get_method_names():
	visibility_changed.connect(on_visibility_changed)
	var methods = []
	for fun in commands.get_script().get_script_method_list():
		methods.append(fun["name"])
	return methods
	
func _ready():
	line_edit.text_submitted.connect(self._on_text_submitted)
	input_commands = get_method_names()
	
func _on_text_submitted(command):
	var error = expression.parse(command)
	if error != OK:
		rich_text_label.newline()
		var error_text = expression.get_error_text()
		rich_text_label.append_text("[color=red]Error: " + error_text + "[/color]")
		line_edit.text = ""
		rich_text_label.newline()
		return
	var result = expression.execute([],commands)
	if not expression.has_execute_failed():
		history.push_front(command)
		rich_text_label.append_text("[color=green]- [/color]"+command)
		rich_text_label.newline()
		rich_text_label.append_text(str(result))
		rich_text_label.newline()
		line_edit.text = ""
	line_edit.call_deferred("grab_focus")
	scale_history()
	current_history_index = -1
	
func _on_line_edit_text_changed(new_text: String) -> void:
	var Match = ""
	for cmd:String in input_commands:
		if cmd.begins_with(new_text):
			Match = cmd
			break
	
	if Match != "" and new_text != "":
		suggestions.text = Match.substr(new_text.length())
		suggestions.position = get_caret_global_position(line_edit)
	else:
		suggestions.text = ""
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		if suggestions.text != "":
			line_edit.text += suggestions.text
			line_edit.caret_column = line_edit.text.length()
			suggestions.text = ""
	
	if history.size() > 0:
		if event.is_action_pressed("ui_up"):
			current_history_index = (current_history_index + 1) % history.size()
			line_edit.text = history[current_history_index]
			line_edit.grab_focus()
			await get_tree().process_frame
			line_edit.caret_column = line_edit.text.length()
		elif event.is_action_pressed("ui_down"):
			#if current_history_index == 0:
				#current_history_index = -1
			#elif current_history_index == -1:
				#current_history_index = history.size() -1
			#else:
			current_history_index = (current_history_index + history.size() -1) % history.size()
			line_edit.text = history[current_history_index]
			line_edit.grab_focus()
			await get_tree().process_frame
			line_edit.caret_column = line_edit.text.length()

func get_caret_global_position(line_edit: LineEdit) -> Vector2:
	var font = line_edit.get_theme_default_font()
	var font_size = line_edit.get_theme_default_font_size()

	var text_up_to_caret = line_edit.text.substr(0, line_edit.caret_column)
	var text_width = font.get_string_size(text_up_to_caret, HORIZONTAL_ALIGNMENT_LEFT, -2, font_size).x

	# Account for scroll offset (if text is scrolled horizontally)
	var padding :int = 4
	var local_caret_pos = Vector2(text_width - line_edit.get_scroll_offset() + padding, line_edit.global_position.y)

	return local_caret_pos

func on_visibility_changed():
	if not visible:
		rich_text_label.text = ""

func scale_history():
	if history.size() > MAX_HISTORY_SIZE:
		history.pop_back()
