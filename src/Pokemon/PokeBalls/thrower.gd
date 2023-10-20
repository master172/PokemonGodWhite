extends Node2D
const pokeBall = preload("res://src/Pokemon/PokeBalls/poke_ball.tscn")
@onready var marker_2d = $Marker2D

var bullet_speed = 1000

signal success
signal faliure

func _throw(at_node):
	look_at(at_node.get_global_position())
	var PokeBall = pokeBall.instantiate()
	PokeBall.rotation_degrees = self.rotation_degrees
	PokeBall.position = marker_2d.get_global_position()
	PokeBall.velocity = ((at_node.get_global_position() - PokeBall.get_global_position()) * bullet_speed)/PokeBall.get_global_position().distance_to(at_node.get_global_position())
	
	PokeBall.connect("catch_sucess",catch_success)
	PokeBall.connect("catch_faliure",catch_faliure)
	
	add_child(PokeBall)

func catch_success():
	emit_signal("success")

func catch_faliure():
	emit_signal("faliure")
