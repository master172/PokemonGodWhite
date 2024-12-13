extends Control

const aiden_timeline = preload("res://src/Dialogs/AidenInteraction.dtl")

var aiden_relationship :int = 0

func _ready():
	Dialogic.connect("signal_event",battle)
	Dialogic.connect("signal_event",no)
	

##you need to make sure that the you dont start a single timeline multiple times
func _input(event:InputEvent):
	# check if a dialog is already running
	if Dialogic.current_timeline != null:
		return
	
	if event is InputEventKey and event.keycode == KEY_ENTER and event.pressed:
		Dialogic.start('AidenInteraction')
		get_viewport().set_input_as_handled()

##handling signals
##from my current understanding the dialogs signals are emitted as a single signal
##the Dialogic autoload emits the signal_event with the signal name as an argument
##connect the signal check the argument and check the timeline as well

##Variables are easy acess in format Dialogic.VAR.Group.Subgroup.Variable
##you can perform normal string manipulation from there easily
##it also follows the {Group.Subgroup.VariableName} convention in the timeline
func battle(Sign):
	if Sign == "Battle":
		if Dialogic.current_timeline == aiden_timeline:
			print_debug("Time for a Battle")
			Dialogic.VAR.Aiden.Relationship = str(10)
func no(Sign):
	if Sign == "No" and Dialogic.current_timeline == aiden_timeline:
		print_debug("Bad Choice")
		Dialogic.VAR.Aiden.Relationship = str(-10)
