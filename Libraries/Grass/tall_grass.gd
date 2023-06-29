extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var GrassStepEfect = preload("res://Libraries/Grass/grass_step_effect.tscn")

var player_inside:bool = false
var grass_overlay : Sprite2D = null

const grass_overlay_texture = preload("res://assets/tallgrass/stepped_tall_grass.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().current_scene.get_node("player").connect("player_moving_signal",player_exiting_grass)
	get_tree().current_scene.get_node("player").connect("player_stopped_signal",player_in_grass)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_in_grass():
	if player_inside == true:
		var grass_step_effect = GrassStepEfect.instantiate()
		self.add_child(grass_step_effect)
		
		grass_overlay = Sprite2D.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.position
		grass_overlay.z_index = 1
		self.add_child(grass_overlay)

func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func _on_area_2d_body_entered(body):
	player_inside = true
	animation_player.play("stepped")
