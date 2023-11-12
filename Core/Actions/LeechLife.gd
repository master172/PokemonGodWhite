extends Action

var User:CharacterBody2D = null

func _ready():#ready overrider
	pass

func set_user(user):
	User = user

func _attack():
	if User.has_method("attack_prep"):
		User.attack_prep()
	if User != null:
		User.velocity = User.velocity * 0.001
	
	User.stun(1)
	User.animate_modulation_change(Color.RED,1)
	if User.is_in_group("Pokemon"):
		User.targetPokemon.animate_modulation_change(Color.BLACK,1)
		User.targetPokemon.stun(1)
		User.targetPokemon.velocity = User.targetPokemon.velocity * 0.001
	elif User.is_in_group("PlayerPokemon"):
		User.opposing_pokemons[0].animate_modulation_change(Color.BLACK,1)
		User.opoosing_pokemons.stun(1)
		User.opoosing_pokemons.velocity = User.opoosing_pokemons.velocity * 0.001
	
	leech_life()
	
func _on_timer_timeout():
	if User.has_method("attack_end"):
		User.attack_end()

	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()


func leech_life():
	if User.is_in_group("Pokemon"):
		holder.calculate_damage(User.targetPokemon,User)

	elif User.is_in_group("PlayerPokemon"):
		holder.calculate_damage(User.opposing_pokemons[0],User)

