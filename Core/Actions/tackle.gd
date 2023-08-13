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
	User.attacking = true
	tackle_timer.wait_time = duration
	tackle_timer.start()
	if User != null:
		User.velocity = User.get_current_facing_direction() * dash_speed
		
func is_tackling():
	return tackle_timer.is_stopped()


func _on_tackle_timer_timeout():
	User.velocity = Vector2.ZERO


func _on_attack_delay_timeout():
	User.attacking = false
	User.state = User.states.NORMAL
	queue_free()


func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon"):
			holder.calculate_damage(body,User)

