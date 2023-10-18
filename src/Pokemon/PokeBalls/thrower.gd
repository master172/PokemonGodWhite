extends Node2D
const pokeBall = preload("res://src/Pokemon/PokeBalls/poke_ball.tscn")
@onready var marker_2d = $Marker2D

var bullet_speed = 1000
func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Yes"):
		var Pokeball = pokeBall.instantiate()
		Pokeball.rotation_degrees = self.rotation_degrees
		Pokeball.position = marker_2d.get_global_position()
		Pokeball.velocity = ((get_global_mouse_position() - Pokeball.position) * bullet_speed)/Pokeball.position.distance_to(get_global_mouse_position())
		

		add_child(Pokeball)
