extends Action

@onready var tackle_timer = $TackleTimer
@onready var attack_delay = $AttackDelay

var User:CharacterBody2D = null

var duration:float = 0.1
var dash_speed:float = 1500

func _ready():#ready overrider
	pass

func set_user(user):
	User = user

func _attack():
	attack_delay.start()
	if User.has_method("attack_prep"):
		User.attack_prep()
	tackle_timer.wait_time = duration
	tackle_timer.start()
	if User != null:
		User.velocity = User.get_current_facing_direction() * dash_speed
		
func is_tackling():
	return tackle_timer.is_stopped()


func _on_tackle_timer_timeout():
	User.velocity = Vector2.ZERO


func _on_attack_delay_timeout():
	if User.has_method("attack_end"):
		User.attack_end()
	SignalBus.connect_attack_completed(self,User)
	emit_signal("attack_finished")
	queue_free()


func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User)
			SignalBus.connect_attack_landed(self,User)
			emit_signal("attack_landed")
