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
	Normal,
	Question
}
var state = State.Normal

signal text_completed
# Called when the node enters the scene tree for the first time.
func _ready():
	set_text_empty()
	process_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.Normal:
		if Input.is_action_just_pressed("Yes"):
			if DialogDisplay.get_visible_ratio() == 1.0:
				process_dialog()
			else:
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
				if current_dialog.Dialogs[current_index].get_dialog_type() == 0:
					show()
					set_text_empty()
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					state = State.Normal
					
					current_index = current_dialog.Dialogs[current_index].next
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 1:
					show()
					set_text_empty()
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					await self.text_completed
					
					
					add_options(dialog)
					state = State.Question
			elif current_index == -1:
				set_text_empty()
				hide()

func add_options(dialog):
	for i in dialog.Options.size() :
		var optionNode = OptionNode.instantiate()
		optionNode.text = dialog.Options[i].text
		options_container.add_child(optionNode)
	set_option_true()

func set_option_true():
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
	current_index = dialog.Options[option].next
	process_dialog()

func Text_completed():
	emit_signal("text_completed")
