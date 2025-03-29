extends TextureRect

@onready var abl_tag = $Ability/AblTag
@onready var at_tag = $Attack/AtTag
@onready var sp_at_tag = $SpAttack/SpAtTag
@onready var def_tag = $Defense/DefTag
@onready var sp_def_tag = $SpDefense/SpDefTag
@onready var spd_tag = $Speed/SpdTag
@onready var health_bar = $HealthBar

func _display(pokemon:game_pokemon):
	abl_tag.text = pokemon.Ability.Name
	health_bar.max_value = pokemon.Max_Health
	health_bar.value = pokemon.Health
	at_tag.text = str(pokemon.Attack, "/" , pokemon.Max_Attack)
	sp_at_tag.text = str(pokemon.Special_Attack, "/" , pokemon.Max_Special_Attack)
	def_tag.text = str(pokemon.Defense, "/" , pokemon.Max_Defense)
	sp_def_tag.text = str(pokemon.Special_Defense, "/" , pokemon.Max_Special_Defense)
	spd_tag.text = str(pokemon.Speed, "/" , pokemon.Max_Speed)
