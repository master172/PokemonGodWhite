extends Node

var AllyPokemons:Poke_list = Poke_list.new()
var EnemyPokemons:Poke_list = Poke_list.new()

func _ready():
	AllyPokemons.Name = "AllyPokemons"
	EnemyPokemons.Name = "EnemyPokemons"
