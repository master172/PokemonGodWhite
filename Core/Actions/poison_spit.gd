extends Action

const POISONED = preload("res://Resources/PokeMon/StatusConditions/Poisoned.tres")

var target:CharacterBody2D
var User:CharacterBody2D

var speed:int = 500

var oneshot:bool = false


func _ready():
	if User != null:
		target = User.opposing_pokemons[0]
		position = self.global_position
		set_as_top_level(true)
func _physics_process(delta):
	if not target:
		position += speed * Vector2.LEFT.rotated(rotation)*delta
		return
	look_at(target.global_position)
	position = position.move_toward(target.global_position,speed * delta)

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
	check_attack(body)

func check_attack(body):
	if body != User:
		if body.is_in_group("Pokemon") or body.is_in_group("PlayerPokemon"):
			holder.calculate_damage(body,User,1)
			body.add_perma_status_condition(POISONED)
			if oneshot == false:
				connect("attack_landed",SignalBus.on_attack_landed)
				oneshot = true
			emit_signal("attack_landed",self,User)
			_end()
