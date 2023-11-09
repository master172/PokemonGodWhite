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
		var Target = target[0].pokemon
		Target.Attack = clamp(Target.Attack + stages,(Target.Max_Attack - 6),(Target.Max_Attack + 6))
		target[0].animate_stat_reduction()
		_end()
		
func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()
