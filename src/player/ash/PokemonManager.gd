extends Node2D

@onready var following_pokemon = get_child(0)

var direction = Vector2.ZERO
var HashMap = {
	Vector2(0,-1):Vector2(0,8),
	Vector2(0,1):Vector2(0,-24),
	Vector2(-1,0):Vector2(16,-8),
	Vector2(1,0):Vector2(-16,-8)
}

func _ready():
	visible = false

func set_seeable():
	visible = true
	
func change_position(Position,Speed):
	if direction != Vector2.ZERO:
		update_direction(direction)
		direction = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(following_pokemon,"global_position",Position,Speed)

func update_direction(Direction):
	following_pokemon.set_direction(Direction)

func jump_ledge(Position,Speed,Direction):
	var tween = get_tree().create_tween()
	tween.tween_property(following_pokemon,"global_position",Position,Speed)
