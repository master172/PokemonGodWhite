extends Node2D

@export var temp_pokemon :NodePath
var Temp_Pokemon

var HashMap = {
	Vector2(0,-1):Vector2(0,8),
	Vector2(0,1):Vector2(0,-24),
	Vector2(-1,0):Vector2(16,-8),
	Vector2(1,0):Vector2(-16,-8)
}
# Called when the node enters the scene tree for the first time.
func _ready():
	Temp_Pokemon = get_node(temp_pokemon)


# Called every frame. 'delta' is the elapsed time since the previous frame.

func change_turning_position(Direction:Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(Temp_Pokemon,"global_position",Utils.Player.global_position - Vector2(0,8),0.2)
