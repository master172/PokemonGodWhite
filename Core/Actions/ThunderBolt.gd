extends Action

@export var attack_pos := Vector2(0,0)

@onready var beam = $Beam
@onready var electric_1 = $Electric1
@onready var electric_2 = $Electric2
@onready var attack_timer = $AttackTimer

var target:Array = []
var User:CharacterBody2D

var knockback_vector = Vector2.ZERO

@export var damage:int = 2

var oneshot:bool = false

func _ready():
	if target != []:
		target[0].stun()
		User.stun()
		attack_timer.start()

func set_user(user):
	User = user

func set_target(Target):
	target = Target
	
func _process(delta):
	beam.look_at(attack_pos)
	beam.scale.x = (self.global_position.distance_to(attack_pos))/128
	electric_2.global_position = attack_pos

func _physics_process(delta):
	if target != null:
		show()
		if User.opposing_pokemons != []:
			if User.opposing_pokemons[0] == target[0]:
				attack_pos = target[0].global_position
				self.global_position = User.global_position
		else:
			queue_free()
	else:
		hide()
		
	

func _on_timer_timeout():
	_end()
	queue_free()


func _on_attack_timer_timeout():
	if target != null:
		if User.opposing_pokemons != []:
			if User.opposing_pokemons[0] == target[0]:
				print("attack")
				holder.calculate_damage(target[0],User)
				if oneshot == false:
					connect("attack_landed",SignalBus.on_attack_landed)
					oneshot = true
				emit_signal("attack_landed",self,User)

func _end():

	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
