extends Node2D
const binding_circle = preload("res://Core/Resources/Binding/binding_circle.tscn")

@export var battle_scene:Node2D 

signal success
signal faliure

func _throw(pokemon:PokeEnemy):
	var Binder = binding_circle.instantiate()
	Binder.position = pokemon.position
	pokemon.stun(2)
	Binder.connect("catch_sucess",catch_success)
	Binder.connect("catch_faliure",catch_faliure)
	
	if battle_scene != null:
		battle_scene.add_child(Binder)
		Binder.construct(pokemon.pokemon)

func catch_success():
	emit_signal("success")

func catch_faliure():
	emit_signal("faliure")
