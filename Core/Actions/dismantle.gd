extends Action

var User:CharacterBody2D = null

var oneshot:bool = false

func set_user(user):
	User = user

func _attack():
	if User != null:
		var to_face = get_direction()
		if to_face != null:
			look_at(to_face)
			print_debug("looking")
			
func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()

func get_direction():
	if User != null:
		if User.opposing_pokemons != []:
			return User.global_position.direction_to(User.opposing_pokemons[0].global_position)

func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			emit_signal("attack_landed",self,User)
