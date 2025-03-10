extends Action

@export var attack_pos := Vector2(0,0)

@onready var string = $String

var target:Array = []
var User:CharacterBody2D

var oneshot:bool = false

func _ready():
	pass

func set_user(user):
	User = user

func set_target(Target):
	target = Target
	
func _process(delta):
	string.look_at(attack_pos)
	string.scale.x = (self.global_position.distance_to(attack_pos))/16

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


func _attack():
	User.velocity = User.velocity * 0.0001
	if target != null:
		if User.opposing_pokemons != []:
			if User.opposing_pokemons[0] == target[0]:
				print("attack")
				var Target :game_pokemon= target[0].pokemon
				Target.speed_stage = clamp(Target.speed_stage - 1,6,6)
				target[0].animate_modulation_change(Color.GRAY,2)
				target[0].movement_speed -= target[0].movement_speed * 0.1
				if target[0].movement_speed <= 30:
					target[0].movement_speed = 30
				if oneshot == false:
					connect("attack_landed",SignalBus.on_attack_landed)
					oneshot = true
				emit_signal("attack_landed",self,User)

func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
