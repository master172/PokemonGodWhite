extends Node2D

@onready var healing_balls = $HealingBalls
@onready var animation_player = $AnimationPlayer
@onready var healing_timer = $HealingTimer


@onready var nurse_joy = $NurseJoy

@export_file var place

func _ready():
	healing_balls.visible = false
	
	
func _on_nurse_joy_start_healing():
	if Utils.get_scene_manager() != null:
		Utils.get_scene_manager().set_current_healing_place(place) 
	healing_balls.visible = true
	var to_heal = AllyPokemon.get_Party_pokemon_size()
	match  to_heal:
		1:
			animation_player.play("One")
		2:
			animation_player.play("Two")
		3:
			animation_player.play("Three")
		4:
			animation_player.play("Four")
		5:
			animation_player.play("Five")
		6:
			animation_player.play("Six")
	healing_timer.start()

func _on_healing_timer_timeout():
	animation_player.stop()
	healing_balls.visible = false


func heal():
	nurse_joy.heal()

func get_heal_pos():
	return Vector2(24,64)
	
func get_heal_dir():
	return Vector2(0,-1)

