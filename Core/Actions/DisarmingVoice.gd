extends Action

var target:Array = []
var User:CharacterBody2D

var knockback_vector = Vector2.ZERO

var oneshot:bool = false

func _ready():
	pass

func set_user(user):
	User = user

func set_target(Target):
	target = Target
	
	

func _on_timer_timeout():
	_end()
	queue_free()


func _attack():
	if target != null:
		if User.opposing_pokemons != []:
			if User.opposing_pokemons[0] == target[0]:
				print("attack")
				target[0].animate_modulation_change(Color(0.749, 0.169, 1))
				holder.calculate_damage(target[0],User,1)
				if oneshot == false:
					connect("attack_landed",SignalBus.on_attack_landed)
					oneshot = true
				emit_signal("attack_landed",self,User)

func _end():

	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
