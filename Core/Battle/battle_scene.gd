extends Node2D

@onready var marker_2d = $Marker2D
@onready var ally_pokemon = $AllyPokemon

const battle_pokemon = preload("res://Core/Battle/battle_pokemon.tscn")
const poke_enemy = preload("res://Core/Battle/poke_enemy.tscn")
# Called when the node enters the scene tree for the first time.
@onready var enemy_pokemon = $EnemyPokemon
@onready var poke_data = $PokeData

func set_enemy(pokemon):
	var Poke_enemy = poke_enemy.instantiate()
	Poke_enemy.pokemon = game_pokemon.new(pokemon[0],pokemon[1])
	Poke_enemy.position = Vector2(603,103)
	enemy_pokemon.add_child(Poke_enemy)
	poke_data.set_enemy(Poke_enemy.pokemon)
	Poke_enemy.connect("health_changed",update_poke_data_enemy)

func _on_hud_pokemon_selected(pokemon):
	var BATTLE_POKEMON = battle_pokemon.instantiate()
	BATTLE_POKEMON.pokemon = AllyPokemon.get_party_pokemon(pokemon)
	BATTLE_POKEMON.position = marker_2d.position
	ally_pokemon.add_child(BATTLE_POKEMON)
	BattleManager.AllyHolders.append(BATTLE_POKEMON)
	BattleManager.AllyPokemons.add_pokemon(AllyPokemon.get_party_pokemon(pokemon))
	poke_data.set_player(BATTLE_POKEMON.pokemon)

func update_poke_data_enemy(body):
	poke_data.set_enemy(body.pokemon)
