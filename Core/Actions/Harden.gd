extends Action


var User:CharacterBody2D

@export_range(-6,6) var stages:int = 0

func _ready():
	pass #ready_overrider
	
func set_user(user):
	User = user


func _attack():
	if User != null:
		var Target = User.pokemon
		Target.Defense = clamp(Target.Defense + stages,(Target.Max_Defense - 6),(Target.Max_Defense + 6))
		User.animate_modulation_change(Color.RED)
		_end()
	
func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()
