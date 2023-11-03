extends Action

@onready var heal = $Heal
@onready var take = $Take

var User:CharacterBody2D = null

var duration:float = 2

var oneshot:bool = false

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
	heal.global_position = User.global_position
	if User.is_in_group("Pokemon"):
		take.global_position = User.targetPokemon.global_position
		User.targetPokemon.stun(1)
		User.targetPokemon.velocity = User.targetPokemon.velocity * 0.001
	elif User.is_in_group("PlayerPokemon"):
		take.global_position = User.opposing_pokemons[0].global_position
		User.opoosing_pokemons.stun(1)
		User.opoosing_pokemons.velocity = User.opoosing_pokemons.velocity * 0.001

func _on_timer_timeout():
	if User.has_method("attack_end"):
		User.attack_end()

	emit_signal("attack_landed",self,User)
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()


func _on_leech_timer_timeout():
	heal.global_position = User.global_position
	if User.is_in_group("Pokemon"):
		User.stun(1)
		User.targetPokemon.stun(1)
		holder.calculate_damage(User.targetPokemon,User)
		take.global_position = User.targetPokemon.global_position
		
	elif User.is_in_group("PlayerPokemon"):
		User.stun(1)
		User.opoosing_pokemons.stun(1)
		holder.calculate_damage(User.opposing_pokemons[0],User)
		take.global_position = User.opposing_pokemons[0].global_position
			
	if oneshot == false:
		connect("attack_landed",SignalBus.on_attack_landed)
	oneshot = true
