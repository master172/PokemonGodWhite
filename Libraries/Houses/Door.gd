extends Area2D

@export_file var next_scene_path = ""

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

func _ready():
	sprite_2d.visible = false
	var player = find_parent("Current_scene").get_children().back().get_node("player")
	player.connect("player_entering_door_signal",enter_door)
	player.connect("player_entered_door_signal",close_door)
	

func enter_door():
	animation_player.play("OpenDoor")

func close_door():
	animation_player.play("CloseDoor")

func door_closed():
	get_node(NodePath("/root/SceneManager")).transition_to_scene(next_scene_path)
