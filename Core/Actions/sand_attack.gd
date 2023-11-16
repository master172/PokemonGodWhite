extends Action


var target:Array = []
var User:CharacterBody2D

var vel_set:bool = false
var vel:Vector2 =Vector2.ZERO

var speed:int = 10

var oneshot:bool = false

func _ready():
	pass

func _physics_process(delta):
	if User != null and vel_set == false:
		vel_set = true
		position += User.get_current_facing_direction() * 16
		vel = User.get_current_facing_direction() * speed
		vel = vel.normalized()
		
	if vel != null:
		position += vel * speed
	
func set_user(user):
	User = user

func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	queue_free()

func _on_timer_timeout():
	_end()


func _on_area_2d_body_entered(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			emit_signal("attack_landed",self,User)
			_end()
