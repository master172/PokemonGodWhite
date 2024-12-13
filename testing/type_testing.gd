extends Node2D

func _ready():
	var pikachu = AllyPokemon.get_party_pokemon(0)
	print(BattleManager.get_type_modifier(pikachu.get_Type1(),"Water"))

