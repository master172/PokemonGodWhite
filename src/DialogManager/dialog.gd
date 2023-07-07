extends Control

@onready var DialogDisplay = $Background/RichTextLabel
@onready var options_container = $OptionsContainer

@export var current_dialog:DialogueLine

var current_index:int = 0
var tween

@onready var OptionNode = preload("res://src/DialogManager/option.tscn")
var processing_dialog = false

var dialog
var handling_options = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_text_empty()
	process_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if processing_dialog == false:
		if Input.is_action_just_pressed("Yes"):
			if DialogDisplay.get_visible_ratio() == 1.0:
				process_dialog()
			else:
				skip_display_animation()
	else:
		handle_question(dialog)
		
func set_text_empty():
	DialogDisplay.set_visible_characters(0)
	DialogDisplay.text = ""
	
func displayText(text):
	DialogDisplay.text = text
	await get_tree().create_timer(0.2).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(DialogDisplay, "visible_ratio", 1, 1)

func skip_display_animation():
	if is_instance_valid(tween):
		tween.stop()
	DialogDisplay.set_visible_ratio(1)
	
func process_dialog():
	if current_dialog != null:
		if current_dialog.Dialogs.size() >= 1:
			if current_index >= 0:
				if current_dialog.Dialogs[current_index].get_dialog_type() == 0:
					show()
					set_text_empty()
					displayText(current_dialog.Dialogs[current_index].text)
					
					dialog = current_dialog.Dialogs[current_index]
					current_index = current_dialog.Dialogs[current_index].next
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 1:
					show()
					set_text_empty()
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					processing_dialog = true
				
			elif current_index == -1:
				set_text_empty()
				hide()

func handle_question(dialog):
	if handling_options == false:
		for i in dialog.Options.size() :
			var optionNode = OptionNode.instantiate()
			optionNode.text = dialog.Options[i].text
			options_container.add_child(optionNode)
	handling_options = true
