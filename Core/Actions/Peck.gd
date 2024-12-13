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
		self.position += direction * 48
		position -= Vector2(0,16)
		if User.is_in_group("Pokemon"):
			var target = User.targetPokemon
			if target != null:
				look_at(target.global_position)
		elif User.is_in_group("PlayerPokemon"):
			look_at(get_direction())
	
func get_direction():
	if User != null:
		if User.opposing_pokemons != []:
			return User.global_position.direction_to(User.opposing_pokemons[0].global_position)


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
