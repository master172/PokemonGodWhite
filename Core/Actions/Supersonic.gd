extends Action

var User:CharacterBody2D = null

var oneshot:bool = false

func _ready():#ready overrider
	pass
	
func set_user(user):
	User = user
	
func _attack():
	if User.has_method("attack_prep"):
		User.attack_prep()
	if User != null:
		User.stun(0.5)



func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()
	
func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User,1)
			var Target = body.pokemon
			Target.Attack = clamp(Target.Attack + -1,(Target.Max_Attack - 6),(Target.Max_Attack + 6))
			body.animate_modulation_change()
			
			User.pokemon.Attack = clamp(User.pokemon.Attack + 1,(User.pokemon.Max_Attack - 6),(User.pokemon.Max_Attack + 6))
			User.animate_modulation_change(Color.RED)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			emit_signal("attack_landed",self,User)
