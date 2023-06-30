extends Node2D

var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_to_scene(new_scene:String):
	next_scene = new_scene
	transition_player.play("FadeToBlack")

func finished_fading():
	current_scene.get_child(0).queue_free()
	current_scene.add_child(load(next_scene).instantiate())
	transition_player.play("FadeToNormal")
