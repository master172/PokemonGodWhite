extends Action



var target:Array = []
var User:CharacterBody2D


var oneshot:bool = false
var prev_speed:int = 0

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
	User.velocity = User.velocity *0.0001
	prev_speed = target[0].movement_speed
	if target != null:
		if User.opposing_pokemons != []:
			if User.opposing_pokemons[0] == target[0]:
				print("attack")
				var rng = randi_range(0,100)
				if rng <75:
					target[0].animate_modulation_change(Color.YELLOW,3)
					
					
					target[0].movement_speed = clamp(target[0].movement_speed*0.2,
					30,
					target[0].movement_speed)
					
				if oneshot == false:
					connect("attack_landed",SignalBus.on_attack_landed)
					oneshot = true
				emit_signal("attack_landed",self,User)

func _end():
	target[0].movement_speed = prev_speed
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
