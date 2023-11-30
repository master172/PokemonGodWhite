extends Control

var player_pokemon:BattlePokemon = null

@onready var databox = $HBoxContainer/Databox
@onready var d_icon = $HBoxContainer/Databox/Icon
@onready var d_name = $HBoxContainer/Databox/Name
@onready var d_level = $HBoxContainer/Databox/Level
@onready var d_health_bar = $HBoxContainer/Databox/HealthBar
@onready var d_exp_bar = $HBoxContainer/Databox/ExpBar
@onready var databox_2 = $HBoxContainer/Databox2
@onready var d2_icon = $HBoxContainer/Databox2/Icon
@onready var d2_name = $HBoxContainer/Databox2/Name
@onready var d2_level = $HBoxContainer/Databox2/Level
@onready var d2_health_bar = $HBoxContainer/Databox2/HealthBar
@onready var d2_exp_bar = $HBoxContainer/Databox2/ExpBar
@onready var pokemons = $HBoxContainer/Databox2/Pokemons
@onready var stamina_bar = $StaminaBar

var previous_stamina

func set_player(pokemon:game_pokemon,num:int = 0):
	if num == 0:
		d_icon.texture = pokemon.get_icon()
		d_name.text = pokemon.Nick_name
		d_level.text = str(pokemon.level)
		set_health_bar(pokemon,d_health_bar)
		set_exp_bar(pokemon,d_exp_bar)

	
func set_enemy(pokemon:game_pokemon,num:int = 0):
	if num == 0:
		d2_icon.texture = pokemon.get_icon()
		d2_name.text = pokemon.Nick_name
		d2_level.text = str(pokemon.level)
		set_health_bar(pokemon,d2_health_bar)
		set_exp_bar(pokemon,d2_exp_bar)

func set_health_bar(pokemon:game_pokemon,health_bar):
	health_bar.max_value = pokemon.Max_Health
	var tween = get_tree().create_tween()
	tween.tween_property(health_bar,"value",pokemon.Health,0.5)

func set_exp_bar(pokemon:game_pokemon,exp_bar):
	exp_bar.max_value = pokemon.exp_to_next_level
	var tween = get_tree().create_tween()
	tween.tween_property(exp_bar,"value",pokemon.exp,0.5)
	exp_bar.min_value = pokemon.exp_to_current_level

func _physics_process(delta):
	pokemons.visible = BattleManager.Trainer_Battle
	if BattleManager.Trainer_Battle == true:
		pokemons.frame = BattleManager.EnemyPokemons.size()
	if player_pokemon != null:
		if player_pokemon.Stamina != previous_stamina:
			set_stamina_bar()
			
func set_stamina_bar():
	stamina_bar.max_value = player_pokemon.MaxStamina
	var tween = get_tree().create_tween()
	tween.tween_property(stamina_bar,"value",player_pokemon.Stamina,0.2)
	await tween.finished
	previous_stamina = player_pokemon.Stamina
