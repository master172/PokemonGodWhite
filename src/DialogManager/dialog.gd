extends Control

@onready var DialogDisplay = $Background/RichTextLabel
@onready var options_container = $OptionsContainer

@export var current_dialog:DialogueLine

var current_index:int = 0
var tween

@onready var OptionNode = preload("res://src/DialogManager/option.tscn")

var dialog

var handling_options :bool = false

var current_selected : int = 0

enum State {
	Empty,
	Normal,
	Question
}
var state = State.Normal

signal text_completed
# Called when the node enters the scene tree for the first time.

#func _ready():
#	Utils.DialogBar = self
#	clear()
	
func _start(dialogueLine:DialogueLine):
	current_index = 0
	current_selected = 0
	handling_options = false
	Utils.DialogProcessing = true
	if Utils.Player != null:
		Utils.Player.set_physics_process(false)
	current_dialog = dialogueLine
	state = State.Normal
	set_text_empty()
	process_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.Normal:
		if Input.is_action_just_pressed("Yes"):
			if DialogDisplay.get_visible_ratio() == 1.0:
				process_dialog()
			elif DialogDisplay.get_visible_ratio() > 0.1:
				skip_display_animation()
	elif state == State.Question:
		handle_questions(dialog)
		
func set_text_empty():
	DialogDisplay.set_visible_characters(0)
	DialogDisplay.text = ""
	
func displayText(text):
	
	DialogDisplay.text = text
	await get_tree().create_timer(0.2).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(DialogDisplay, "visible_ratio", 1, 1)
	tween.connect("finished",Text_completed)
	
func skip_display_animation():
	if is_instance_valid(tween):
		tween.stop()
	DialogDisplay.set_visible_ratio(1)
	emit_signal("text_completed")
	
func process_dialog():
	if current_dialog != null:
		if current_dialog.Dialogs.size() >= 1:
			if current_index >= 0:
				current_dialog.replace_symbols(current_index)
				if current_dialog.Dialogs[current_index].get_dialog_type() == 0:
					show()
					set_text_empty()
					call_functions()
					
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					state = State.Normal
					
					current_index = current_dialog.Dialogs[current_index].next
					
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 1:
					show()
					set_text_empty()
					call_functions()
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					await self.text_completed
					
					
					add_options(dialog)
					state = State.Question
				
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 2:
					change_variables()
					
					if current_dialog.Dialogs[current_index].ChNext != 0:
						current_index = current_dialog.Dialogs[current_index].ChNext
					else:
						current_index += 1
					

					process_dialog()
					
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 4:
					current_dialog.Dialogs[current_index].set_variables.add()
					if current_dialog.Dialogs[current_index].StNext != 0:
						current_index = current_dialog.Dialogs[current_index].StNext
					else:
						current_index += 1
					
					print(Global.Global_Variables.values())
					process_dialog()
					
			elif current_index == -1:
				clear()
		else:
			clear()
	else:
		clear()

func add_options(dialog):
	for i in dialog.Options.size() :
		var optionNode = OptionNode.instantiate()
		optionNode.text = dialog.Options[i].text
		options_container.add_child(optionNode)
	
	set_option_true()

func set_option_true():
	if is_instance_valid(options_container.get_child(current_selected)):
		options_container.get_child(current_selected).change_selected(true)
	
func handle_questions(dialog):
	if Input.is_action_just_pressed("W"):
		options_container.get_child(current_selected).change_selected(false)
		
		if current_selected == 0:
			current_selected = (dialog.Options.size() - 1)
		else:
			current_selected = current_selected- 1
			
		options_container.get_child(current_selected).change_selected(true)
		
	elif Input.is_action_just_pressed("S"):
		options_container.get_child(current_selected).change_selected(false)
		current_selected = (current_selected + 1) % dialog.Options.size()
		options_container.get_child(current_selected).change_selected(true)
	
	if Input.is_action_just_pressed("Yes"):
		handle_input_choice(dialog,current_selected)

func handle_input_choice(dialog,option):
	current_selected = 0
	for i in options_container.get_children():
		i.queue_free()
	
	call_option_function(dialog.Options[option])
	current_index = dialog.Options[option].next
	process_dialog()

func Text_completed():
	emit_signal("text_completed")

func clear():
	current_index = 0
	handling_options = false
	current_selected = 0
	set_text_empty()
	hide()
	current_dialog = null
	state = State.Empty
	await get_tree().create_timer(0.5).timeout
	Utils.DialogProcessing = false
	if Utils.Player != null:
		Utils.Player.set_physics_process(true)

func call_functions():
	if current_dialog.Dialogs[current_index].functions.size() >= 1:
		for i in current_dialog.Dialogs[current_index].functions:
			if i.parameters.size() >= 1:
				get_node(i.callable).call_deferred(i.function,i.parameters)
			else:
				get_node(i.callable).call_deferred(i.function)

func call_option_function(index:Option):
	for i in index.functions:
		if i.parameters.size() >= 1:
			get_node(i.callable).call_deferred(i.function,i.parameters)
		else:
			get_node(i.callable).call_deferred(i.function)
			
func test_function():
	print("test")

func change_variables():
	for i in current_dialog.Dialogs[current_index].change_variables:
		var node = i.node
		var variable = i.variable
		if get_node(node).has_method("changeVariables"):
			get_node(node).changeVariables(variable)

var Viq :int = 2
func changeVariables(variable):
	var map_dict:Dictionary = {
		"Viq":Viq
	}
	for key in variable.keys():
		var value = variable[key]
		if map_dict.has(key):
			map_dict[key] = value
	print(variable.keys())
	print(map_dict)
	print(Viq)
