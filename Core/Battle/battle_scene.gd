extends Node2D

const battle_pokemon = preload("res://Core/Battle/battle_pokemon.tscn")
const poke_enemy = preload("res://Core/Battle/poke_enemy.tscn")

@onready var marker_2d = $Marker2D
@onready var ally_pokemon = $AllyPokemon
@onready var enemy_pokemon = $EnemyPokemon
@onready var poke_data = $PokeData
@onready var dialog_handler = $DialogHandler

signal stop
signal poke_enemy_stop

signal player_attacked(player)

var allys :Array[BattlePokemon] = []
var opponents :Array[PokeEnemy] = []

func set_enemy(pokemon):
	var Poke_enemy = poke_enemy.instantiate()
	Poke_enemy.pokemon = game_pokemon.new(pokemon[0],pokemon[1])
	Poke_enemy.position = Vector2(603,103)
	
	enemy_pokemon.add_child(Poke_enemy)
	poke_data.set_enemy(Poke_enemy.pokemon)
	
	Poke_enemy.connect("health_changed",update_poke_data_enemy)
	Poke_enemy.connect("defeated",defeating_dialog)
	
	connect("poke_enemy_stop",Poke_enemy._stop)
	connect("player_attacked",Poke_enemy.player_attacked)
	
	opponents.append(Poke_enemy)
	set_opposers()
	
func _on_hud_pokemon_selected(pokemon):
	var BATTLE_POKEMON = battle_pokemon.instantiate()
	BATTLE_POKEMON.pokemon = AllyPokemon.get_party_pokemon(pokemon)
	BATTLE_POKEMON.position = marker_2d.position
	ally_pokemon.add_child(BATTLE_POKEMON)
	
	BattleManager.AllyHolders.append(BATTLE_POKEMON)
	BattleManager.AllyPokemons.add_pokemon(AllyPokemon.get_party_pokemon(pokemon))
	
	poke_data.set_player(BATTLE_POKEMON.pokemon)
	
	BATTLE_POKEMON.connect("health_changed",update_poke_data_player)
	BATTLE_POKEMON.connect("defeated",battle_pokemon_defeated)
	BATTLE_POKEMON.connect("attacked",_player_attacked)
	BATTLE_POKEMON.connect("run",_run)
	
	connect("stop",BATTLE_POKEMON._stop)
	
	allys.append(BATTLE_POKEMON)
	set_opposers()
	
func set_opposers():
	for i in allys:
		i.opposing_pokemons = opponents
	
	for i in opponents:
		i.opposing_pokemons = allys
	
func battle_pokemon_defeated(pokemon,loser):
	allys.erase(loser)
	set_opposers()
	emit_signal("stop")
	emit_signal("poke_enemy_stop")
	dialog_handler.battle_pokemon_defeated(pokemon)
	
	
func update_poke_data_enemy(body):
	poke_data.set_enemy(body.pokemon)

func update_poke_data_player(body):
	poke_data.set_player(body.pokemon)

func defeating_dialog(pokemon:game_pokemon,body:BattlePokemon,loser:PokeEnemy):
	opponents.erase(loser)
	set_opposers()
	emit_signal("stop")
	
	body.pokemon.Level_up.connect(case_level_up.bind(pokemon,body))
	body.pokemon.experience_added.connect(case_experience_added.bind(pokemon,body))
	pokemon.give_experience_points(body.pokemon)
	
	
func case_level_up(pokemon,body):
	poke_data.set_player(body.pokemon)
	dialog_handler.add_won_dialog_level_up(pokemon,body.pokemon)

func case_experience_added(pokemon,body):
	poke_data.set_player(body.pokemon)
	dialog_handler.add_won_dialog(pokemon,body.pokemon)

func _player_attacked(player):
	emit_signal("player_attacked",player)

func _run():
	print_debug("run function")
	emit_signal("stop")
	emit_signal("poke_enemy_stop")
	dialog_handler._run()
