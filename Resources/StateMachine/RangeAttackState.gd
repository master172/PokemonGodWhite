extends State
class_name RangeAttackState

@export var actor:PokeEnemy

var move_index:int = 0
var pokemon:game_pokemon =null

signal attackFinished

func _ready():
	SignalBus.attack_finished.connect(_finished_attack)
	
func _enter_state():
	print("enter attack")
#	print("attack")
	await get_tree().create_timer(0.1).timeout
	
	attack()
	
func attack():
	actor.pokemon.initiate_attack(move_index,actor)

func _finished_attack(attack,user):
	emit_signal("attackFinished")

