extends Control

@onready var DialogDisplay = $Background/RichTextLabel

@export var current_dialog:DialogueLine

var current_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	set_text_empty()
	process_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Yes"):
		process_dialog()

func set_text_empty():
	DialogDisplay.set_visible_characters(0)
	DialogDisplay.text = ""
	
func displayText(text):
	DialogDisplay.text = text
	await get_tree().create_timer(0.2).timeout
	
	var tween = get_tree().create_tween()
	tween.tween_property(DialogDisplay, "visible_ratio", 1, 1)

func process_dialog():
	if current_dialog != null:
		if current_dialog.Dialogs.size() >= 1:
			if current_index <= (current_dialog.Dialogs.size() -1):
				show()
				set_text_empty()
				displayText(current_dialog.Dialogs[current_index].text)
				current_index += 1
			else:
				set_text_empty()
				hide()
