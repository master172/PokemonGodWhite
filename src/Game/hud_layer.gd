extends CanvasLayer

@onready var RouteLabel = $Control/Panel/Label
@onready var AnimPlayer = $Control/AnimationPlayer

func DisplayMapName(Name: String):
    RouteLabel.text = Name
    AnimPlayer.play("DisplayMapIdentifier")