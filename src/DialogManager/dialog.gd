extends Control

@onready var DialogDisplay = $Background/RichTextLabel
@onready var options_container = $OptionsContainer
@onready var actors = $Actors
@onready var speakers = $Actors/Speakers
@onready var listners = $Actors/Listners

@export var current_dialog:DialogueLine

var current_index:int = 0
var tween

@onready var OptionNode = preload("res://src/DialogManager/option.tscn")
@onready var ActorNode = preload("res://src/DialogManager/actor.tscn")

var dialog

var handling_options :bool = false
var changing_dialog :bool = false

var current_selected : int = 0

enum State {
	Empty,
	Normal,
	Question
}
var state = State.Normal

signal text_completed

#signals for feature completeness
signal started(DialogLine)
signal finsished(DialogLine)
signal dialogLine_Changed(DialogLine)

signal dialog_changed(DialogNo)

signal StartOptions(Options)
signal option(OptionNo)

signal Functions(FunctionNo)

signal index_changed(at)
# Called when the node enters the scene tree for the first time.

func _ready():
	Utils.DialogBar = self
	clear()
	
func _start(dialogueLine:DialogueLine):
	#handling necessary variables
	current_index = 0
	index_changed.emit(current_index)
	current_selected = 0
	handling_options = false
	Utils.DialogProcessing = true
	
	#Stopping the player
	if Utils.Player != null:
		Utils.Player.set_physics_process(false)
	
	#Changing states
	current_dialog = dialogueLine
	state = State.Normal
	
	set_text_empty()
	
	started.emit(current_dialog)
	
	process_dialog()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if changing_dialog == false:
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
				
				get_rid_of_actors()
				
				dialog_changed.emit(current_dialog.Dialogs[current_index])
				
				current_dialog.replace_symbols(current_index)
				
				
				if current_dialog.Dialogs[current_index].get_dialog_type() == 0:
					show()
					set_text_empty()
					call_functions()
					
					add_actors(current_dialog.Dialogs[current_index])
					
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					state = State.Normal
					
					current_index = current_dialog.Dialogs[current_index].next
					index_changed.emit(current_index)
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 1:
					show()
					set_text_empty()
					call_functions()
					
					add_actors(current_dialog.Dialogs[current_index])
					
					displayText(current_dialog.Dialogs[current_index].text)
					dialog = current_dialog.Dialogs[current_index]
					await self.text_completed
					
					
					add_options(dialog)
					state = State.Question
				elif current_dialog.Dialogs[current_index].get_dialog_type() == 2:
					changing_dialog = true
					call_functions()
					
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
	
	StartOptions.emit(dialog.Options)
	set_option_true()

func set_option_true():
	if is_instance_valid(options_container.get_child(current_selected)):
		options_container.get_child(current_selected).change_selected(true)
	
func handle_questions(dialog):
	if Input.is_action_just_pressed("W"):
		options_container.get_child(current_selected).change_selected(false)
		
		current_selected = (current_selected - 1) % dialog.Options.size()
			
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
	
	index_changed.emit(current_index)
	
	process_dialog()

func Text_completed():
	emit_signal("text_completed")

func clear():
	current_index = 0
	index_changed.emit(current_index)
	handling_options = false
	current_selected = 0
	set_text_empty()
	hide()
	
	state = State.Empty
	await get_tree().create_timer(0.5).timeout
	Utils.DialogProcessing = false
	
	finsished.emit(current_dialog)
	current_dialog = null

func call_functions():
	if current_dialog.Dialogs[current_index].functions.size() >= 1:
		for i in current_dialog.Dialogs[current_index].functions:
			Functions.emit(i)
			if i.parameters.size() >= 1:
				get_node(i.callable).call_deferred(i.function,i.parameters)
			else:
				print(i.callable)
				get_node(i.callable).call_deferred(i.function)

func call_option_function(index:Option):
	option.emit(index)
	for i in index.functions:
		Functions.emit(i)
		if i.parameters.size() >= 1:
			get_node(i.callable).call_deferred(i.function,i.parameters)
		else:
			get_node(i.callable).call_deferred(i.function)
	

func test_function():
	print("test")

func Change_Dialog(param,at_what:int = 0):
	current_dialog = param[0]
	current_index = at_what
	index_changed.emit(current_index)
	dialogLine_Changed.emit(current_dialog)
	changing_dialog = false
	process_dialog()

func add_actors(dialog:Dialog):
	if dialog.Actors.size() >= 1:
		for i in dialog.Actors:
			var Actor_Type = i.get_actor_type()
			if Actor_Type == 0:
				pass
			elif Actor_Type == 1:
				pass
			elif Actor_Type == 2:
				var speaker = ActorNode.instantiate()
				speaker.texture = i.get_sprite()
				speakers.add_child(speaker)
			elif Actor_Type == 3:
				var listner = ActorNode.instantiate()
				listner.texture = i.get_sprite()
				listner.flip_h = true
				listners.add_child(listner)

func get_rid_of_actors():
	for i in speakers.get_children():
		i.queue_free()
	for i in listners.get_children():
		i.queue_free()

func save():
	Utils.save_data()
