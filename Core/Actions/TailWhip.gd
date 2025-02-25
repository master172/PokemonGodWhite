extends Action


var target:Array = []
var User:CharacterBody2D

@export_range(-6,6) var stages:int = 0

func _ready():
	pass #ready_overrider
	
func set_user(user):
	User = user

func set_target(Target):
	target = Target

func _attack():
	if target != []:
		var Target :game_pokemon = target[0].pokemon
		Target.defense_stage = clamp(Target.defense_stage + stages,-6,6)
		print_debug("target defense stage = ",Target.defense_stage)
		target[0].animate_modulation_change()
		_end()
		
func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()
