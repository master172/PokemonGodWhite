extends Action

@onready var quick_attack_timer = $QuickAttackTimer
@onready var attack_delay = $AttackDelay

var User:CharacterBody2D = null

var duration:float = 0.2
var dash_speed:float = 1700

var oneshot:bool = false
func _ready():#ready overrider
	pass

func set_user(user):
	User = user

func _attack():
	attack_delay.start()
	if User.has_method("attack_prep"):
		User.attack_prep()
	quick_attack_timer.wait_time = duration
	quick_attack_timer.start()
	if User != null:
		User.tackle = true
		User.velocity = User.get_current_facing_direction() * dash_speed
		
func is_tackling():
	return quick_attack_timer.is_stopped()

func get_direction():
	if User != null:
		if User.opposing_pokemons != []:
			return User.global_position.direction_to(User.opposing_pokemons[0].global_position)


func _on_quick_attack_timer_timeout():
	await get_tree().create_timer(0.1).timeout
	User.velocity = User.velocity * 0.001
	User.tackle = false


func _on_attack_delay_timeout():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()


func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			
			emit_signal("attack_landed",self,User)
			await get_tree().create_timer(0.1).timeout
			User.velocity = User.velocity * 0.001
