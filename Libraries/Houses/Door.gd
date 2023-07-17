extends Area2D

@export_file var next_scene_path = ""

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var invisible:bool = false

@export var Spawn_location:Vector2 = Vector2(0,0)
@export var Spawn_direction:Vector2 = Vector2(0,0)

var player_entered:bool = false


func _ready():
	if invisible == true:
		visible = false
	sprite_2d.visible = false
	var player = Utils.get_player()
	player.connect("player_entering_door_signal",enter_door)
	player.connect("player_entered_door_signal",close_door)
	

func enter_door():
	if player_entered == true:
		animation_player.play("OpenDoor")

func close_door():
	if player_entered == true:
		animation_player.play("CloseDoor")

func door_closed():
	if player_entered == true:
		Utils.get_scene_manager().transition_to_scene(next_scene_path,Spawn_location,Spawn_direction)
	


func _on_body_entered(body):
	player_entered = true


func _on_body_exited(body):
	player_entered = false
