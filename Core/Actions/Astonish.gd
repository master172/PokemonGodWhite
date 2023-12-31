extends Action

var User:CharacterBody2D = null
var oneshot:bool = false

func _ready():#ready overrider
	pass
	
func set_user(user):
	User = user
	

func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	print("yo")
	queue_free()
	
func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			body.stun(2)
			body.animate_modulation_change(Color.BLACK,2)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			emit_signal("attack_landed",self,User)
