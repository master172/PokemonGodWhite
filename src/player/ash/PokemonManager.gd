extends Node2D

@onready var following_pokemon = $pokemon

var HashMap = {
	Vector2(0,-1):Vector2(0,8),
	Vector2(0,1):Vector2(0,-24),
	Vector2(-1,0):Vector2(16,-8),
	Vector2(1,0):Vector2(-16,-8)
}

func _ready():
	visible = false
	global_position -= Vector2(0,16)
	
func set_seeable():
	visible = true
	
func change_position(Position,Speed,Direction):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Position - Vector2(0,16),Speed)
	await tween.finished
	update_direction(Direction)

func set_direction(Direction):
	await self.ready
	update_direction(Direction)
	
func update_direction(Direction):
	following_pokemon.set_direction(Direction)
	Utils.get_player().poke_pos = self.global_position
	Utils.get_player().pokeDirection = Direction

func change_position_to_ledge(Position,Speed,Direction):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Position - Vector2(0,16),Speed)
	await tween.finished
	update_direction(Direction)
