extends Node2D

var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene

var player_location
var player_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_to_scene(new_scene:String, spawn_location:Vector2, spawn_direction:Vector2):
	player_location = spawn_location
	player_direction = spawn_direction
	next_scene = new_scene
	transition_player.play("FadeToBlack")

func finished_fading():
	current_scene.get_child(0).queue_free()
	current_scene.add_child(load(next_scene).instantiate())
	transition_player.play("FadeToNormal")
	var player = get_node("Current_scene").get_children().back().get_node("player")
	player.set_spawn(player_location,player_direction)
