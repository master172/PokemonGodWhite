extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

@onready var sprite_2d = $Sprite2D
@onready var canvas_player = $CanvasPlayer

signal start_healing

func _ready():
	animation_player.play("Default")
	Dialogic.connect("signal_event",healing)
	
func _interact():
	Utils.get_player().set_physics_process(false)
	Dialogic.start("NurseJoyDefault")

func healing(Sign):
	if Sign == "PokeCenterNo":
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process_custom(true)
	elif Sign == "PokeCenterYes":
		animation_player.play("Heal")
		AllyPokemon.all_heal()
		emit_signal("start_healing")
	elif Sign == "TurnBack":
		animation_player.play("Default")
	elif Sign == "HealingDone":
		animation_player.play("Bow")
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process_custom(true)
		Utils.autosave()
		
func heal():
	Utils.get_player().set_physics_process(false)
	Dialogic.start("NurseJoyEmergency")
