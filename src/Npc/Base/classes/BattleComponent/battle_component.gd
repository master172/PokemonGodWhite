extends Node2D
class_name BattleComponent

func _ready():
	if get_parent() != null:
		get_parent().set_battle_component(self)
		
func battle(my_pokemons,map):
	Utils.get_scene_manager().transistion_trainer_battle_scene(my_pokemons,map)
