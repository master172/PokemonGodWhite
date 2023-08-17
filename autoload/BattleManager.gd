extends Node



var normal_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 0.5,
	Bug = 1,
	Ghost = 0,
	Steel = 0.5,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 1,
	Dark = 1,
	Fairy = 1
}
var fighting_type:Dictionary = {
	Normal = 2,
	Fighting = 1,
	Flying = 0.5,
	Poison = 0.5,
	Ground = 1,
	Rock = 2,
	Bug = 0.5,
	Ghost = 0,
	Steel = 2,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 0.5,
	Ice = 2,
	Dragon = 1,
	Dark = 2,
	Fairy = 0.5
}
var flying_type:Dictionary = {
	Normal = 1,
	Fighting = 2,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 0.5,
	Bug = 2,
	Ghost = 1,
	Steel = 0.5,
	Fire = 1,
	Water = 1,
	Grass = 2,
	Electric = 0.5,
	Psychic = 1,
	Ice = 1,
	Dragon = 1,
	Dark = 1,
	Fairy = 1
}
var poison_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 0.5,
	Ground = 0.5,
	Rock = 0.5,
	Bug = 1,
	Ghost = 0.5,
	Steel = 0,
	Fire = 1,
	Water = 1,
	Grass = 2,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 1,
	Dark = 1,
	Fairy = 2
}
var ground_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 0,
	Poison = 2,
	Ground = 1,
	Rock = 2,
	Bug = 0.5,
	Ghost = 1,
	Steel = 2,
	Fire = 2,
	Water = 1,
	Grass = 0.5,
	Electric = 2,
	Psychic = 1,
	Ice = 1,
	Dragon = 1,
	Dark = 1,
	Fairy = 1
}
var rock_type:Dictionary = {
	Normal = 1,
	Fighting = 0.5,
	Flying = 2,
	Poison = 1,
	Ground = 0.5,
	Rock = 1,
	Bug = 2,
	Ghost = 1,
	Steel = 0.5,
	Fire = 2,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 1,
	Ice = 2,
	Dragon = 1,
	Dark = 1,
	Fairy = 1
}
var bug_type:Dictionary = {
	Normal = 1,
	Fighting = 0.5,
	Flying = 0.5,
	Poison = 0.5,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 0.5,
	Steel = 0.5,
	Fire = 0.5,
	Water = 1,
	Grass = 2,
	Electric = 1,
	Psychic = 2,
	Ice = 1,
	Dragon = 1,
	Dark = 2,
	Fairy = 0.5
}
var ghost_type:Dictionary = {
	Normal = 0,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 2,
	Steel = 1,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 2,
	Ice = 1,
	Dragon = 1,
	Dark = 0.5,
	Fairy = 1
}
var steel_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 2,
	Bug = 1,
	Ghost = 1,
	Steel = 0.5,
	Fire = 0.5,
	Water = 0.5,
	Grass = 1,
	Electric = 0.5,
	Psychic = 1,
	Ice = 2,
	Dragon = 1,
	Dark = 1,
	Fairy = 2
}
var fire_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 0.5,
	Bug = 2,
	Ghost = 1,
	Steel = 2,
	Fire = 0.5,
	Water = 0.5,
	Grass = 2,
	Electric = 1,
	Psychic = 1,
	Ice = 2,
	Dragon = 0.5,
	Dark = 1,
	Fairy = 1
}
var water_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 2,
	Rock = 2,
	Bug = 1,
	Ghost = 1,
	Steel = 1,
	Fire = 2,
	Water = 0.5,
	Grass = 0.5,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 0.5,
	Dark = 1,
	Fairy = 1
}
var grass_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 0.5,
	Poison = 0.5,
	Ground = 2,
	Rock = 2,
	Bug = 0.5,
	Ghost = 1,
	Steel = 0.5,
	Fire = 0.5,
	Water = 2,
	Grass = 0.5,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 0.5,
	Dark = 1,
	Fairy = 1
}
var electric_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 2,
	Poison = 1,
	Ground = 0,
	Rock = 1,
	Bug = 1,
	Ghost = 1,
	Steel = 1,
	Fire = 1,
	Water = 2,
	Grass = 0.5,
	Electric = 0.5,
	Psychic = 1,
	Ice = 1,
	Dragon = 0.5,
	Dark = 1,
	Fairy = 1
}
var psychic_type:Dictionary = {
	Normal = 1,
	Fighting = 2,
	Flying = 1,
	Poison = 2,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 1,
	Steel = 0.5,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 0.5,
	Ice = 1,
	Dragon = 1,
	Dark = 0,
	Fairy = 1
}
var ice_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 2,
	Poison = 1,
	Ground = 2,
	Rock = 1,
	Bug = 1,
	Ghost = 1,
	Steel = 0.5,
	Fire = 0.5,
	Water = 0.5,
	Grass = 2,
	Electric = 1,
	Psychic = 1,
	Ice = 0.5,
	Dragon = 2,
	Dark = 1,
	Fairy = 1
}
var dragon_type:Dictionary = {
	Normal = 1,
	Fighting = 1,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 1,
	Steel = 0.5,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 2,
	Dark = 1,
	Fairy = 0
}
var dark_type:Dictionary = {
	Normal = 1,
	Fighting = 0.5,
	Flying = 1,
	Poison = 1,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 2,
	Steel = 1,
	Fire = 1,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 2,
	Ice = 1,
	Dragon = 1,
	Dark = 0.5,
	Fairy = 0.5
}
var fairy_type:Dictionary = {
	Normal = 1,
	Fighting = 2,
	Flying = 1,
	Poison = 0.5,
	Ground = 1,
	Rock = 1,
	Bug = 1,
	Ghost = 1,
	Steel = 0.5,
	Fire = 0.5,
	Water = 1,
	Grass = 1,
	Electric = 1,
	Psychic = 1,
	Ice = 1,
	Dragon = 2,
	Dark = 2,
	Fairy = 1
}
@onready var Types :Dictionary = {
	Normal = normal_type,
	Fighting = fighting_type,
	Flying = flying_type,
	Poison = poison_type,
	Ground = ground_type,
	Rock = rock_type,
	Bug = bug_type,
	Ghost = ghost_type,
	Steel = steel_type,
	Fire = fire_type,
	Water = water_type,
	Grass = grass_type,
	Electric = electric_type,
	Psychic = psychic_type,
	Ice = ice_type,
	Dragon = dragon_type,
	Dark = dark_type,
	Fairy = fairy_type
}

var AllyPokemons:Poke_list = Poke_list.new()
var EnemyPokemons:Poke_list = Poke_list.new()

var AllyHolders:Array[BattlePokemon] = []
var EnemyHolders:Array[PokeEnemy] = []
func _ready():
	AllyPokemons.Name = "AllyPokemons"
	EnemyPokemons.Name = "EnemyPokemons"


func get_type_modifier(attacker:String,defender:String):
	var a = Types[attacker]
	var b = a[defender]
	return b
