extends Node

var AllyPokemons:Poke_list = Poke_list.new()
var EnemyPokemons:Poke_list = Poke_list.new()

var AllyHolders:Array[BattlePokemon] = []
var EnemyHolders:Array[PokeEnemy] = []
func _ready():
	AllyPokemons.Name = "AllyPokemons"
	EnemyPokemons.Name = "EnemyPokemons"
