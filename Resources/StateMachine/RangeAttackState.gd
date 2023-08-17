extends State
class_name RangeAttackState

@export var actor:PokeEnemy

var move_index:int = 0
var pokemon:game_pokemon =null

signal attackFinished(attack,user)
signal attackLanded(attack,user)
func _ready():
	SignalBus.attack_finished.connect(_finished_attack)
	SignalBus.attack_landed.connect(_attack_landed)
	
func _enter_state():
	print("range_attack")
	await get_tree().create_timer(0.1).timeout
	
	attack()
	
func attack():
	actor.pokemon.initiate_attack(move_index,actor)

func _finished_attack(attack,user):
	emit_signal("attackFinished",attack,user)

func _attack_landed(attack,user):
	emit_signal("attackLanded",attack,user)
