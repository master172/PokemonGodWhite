extends Node
class_name EnemyAIManager

var current_ai:EnemyAI = WildAI

@export var WildAI:EnemyAI = null
@export var basic_trainer_ai:BasicTrainerAI = null

@onready var ai_level_map:Dictionary[int,EnemyAI] = {
	0:WildAI,
	1:basic_trainer_ai,
}

func _ready() -> void:
	current_ai = ai_level_map[BattleManager.current_ai_level]
	
func choose_attack(pokemon:PokeEnemy,enemy_pokemon:BattlePokemon):
	return current_ai.choose_attack(pokemon,enemy_pokemon)

func reset_attacks():
	current_ai.reset_attacks()
