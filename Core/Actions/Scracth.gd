extends Action

@onready var animated_sprite_2d = $AnimatedSprite2D
var User:CharacterBody2D = null

var oneshot:bool = false

func set_user(user):
	User = user

func _attack():
	animated_sprite_2d.play("Attack")
	if User != null:
		var direction = User.get_current_facing_direction()
		self.position += direction * 64
		if direction == Vector2(0,-1):
			self.rotation_degrees = 14
		elif direction == Vector2(0,1):
			self.rotation_degrees = 97.5
		elif direction == Vector2(-1,0):
			self.rotation_degrees = 0
		elif direction == Vector2(1,0):
			self.rotation_degrees = -76
		User.velocity = User.velocity * 0.001
		
func _on_animated_sprite_2d_animation_finished():
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
