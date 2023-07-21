extends Node2D

@onready var following_pokemon = get_child(0)

var direction = Vector2.ZERO
var HashMap = {
	Vector2(0,-1):Vector2(0,8),
	Vector2(0,1):Vector2(0,-24),
	Vector2(-1,0):Vector2(16,-8),
	Vector2(1,0):Vector2(-16,-8)
}

var jumping_over_ledge:bool = false
func _ready():
	visible = false

func set_seeable():
	visible = true
	
func change_position(Position,Speed):
	if direction != Vector2.ZERO:
		update_direction(direction)
		direction = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Position,Speed)

func update_direction(Direction):
	jumping_over_ledge = false
	following_pokemon.set_direction(Direction)

func jump_ledge(Direction):
	jumping_over_ledge = true
	direction = Direction
	
func _physics_process(delta):
	if jumping_over_ledge == true:
		if Utils.Player.get_current_facing_direction() == Vector2(0,-1) or Utils.Player.get_current_facing_direction() == Vector2(0,1):
			self.global_position.y = Utils.Player.global_position.y
		else:
			self.global_position.x = Utils.Player.global_position.x
	
