extends CanvasLayer

@onready var RouteLabel = $Control/Panel/Label
@onready var name_player: AnimationPlayer = $Control/NamePlayer
@onready var save_player: AnimationPlayer = $Control/SavePlayer


func DisplayMapName(Name: String):
	RouteLabel.text = Name
	name_player.play("DisplayMapIdentifier")

func DisplaySave():
	save_player.play("DisplaySave")
