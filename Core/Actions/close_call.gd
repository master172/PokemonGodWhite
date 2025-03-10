extends Action

var User:BattlePokemon = null
var target:Array = []
var Target :PokeEnemy

@export var scale_factor:int = 100

func _ready():#ready overrider
	pass

func set_target(Target):
	target = Target

func set_user(user):
	User = user

	
func _attack():
	var tween = get_tree().create_tween()
	tween.tween_property(User,"modulate",Color.BLACK,0.6)
	await tween.finished

func reset_modulation():
	var tween = get_tree().create_tween()
	tween.tween_property(User,"modulate",Color.WHITE,0.6)
	await tween.finished
	
func warp():
	
	if target != []:
		Target = target[0]
	
	var teleport_position = Target.position - Target.get_current_facing_direction()*scale_factor
	User.position = teleport_position
	User.input_direction = Target.get_current_facing_direction()
 

func _end():
	if User.has_method("attack_end"):
		User.attack_end()
	connect("attack_finished",SignalBus.attack_completed)
	emit_signal("attack_finished",self,User)
	
	queue_free()
