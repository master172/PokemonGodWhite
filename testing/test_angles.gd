extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var sprite_2d_2 = $Sprite2D2
@onready var sprite_2d_3 = $Sprite2D3

var side:int =0 

func _ready():
	var arr = [-1,1]
	var rng = RandomNumberGenerator.new()
	
	side = arr[rng.randi() % arr.size()]
	print(side)
func _set_game():
	var vec = get_perpendicular_vector()
	sprite_2d_3.position = (sprite_2d.position + vec * sprite_2d.position.distance_to(sprite_2d_2.position))

func get_perpendicular_vector():
	var dir = sprite_2d.position.direction_to(sprite_2d_2.position)
	return dir.rotated(deg_to_rad(90 * side))

func _physics_process(delta):
	sprite_2d_2.position = get_global_mouse_position()
	_set_game()
