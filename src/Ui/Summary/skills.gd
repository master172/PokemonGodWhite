extends ColorRect

@onready var abl_tag: Label = $MainContainer/Items/AblTag
@onready var at_tag: Label = $MainContainer/Items/AtTag
@onready var sp_at_tag: Label = $MainContainer/Items/SpAtTag
@onready var def_tag: Label = $MainContainer/Items/DefTag
@onready var sp_def_tag: Label = $MainContainer/Items/SpDefTag
@onready var spd_tag: Label = $MainContainer/Items/SpdTag
@onready var health_bar: ProgressBar = $MainContainer/Items/HealthBar


func _display(pokemon:game_pokemon):
	if pokemon.Ability != null:
		abl_tag.text = pokemon.Ability.Name
	health_bar.max_value = pokemon.Max_Health
	health_bar.value = pokemon.Health
	at_tag.text = str(pokemon.Attack, "/" , pokemon.Max_Attack)
	sp_at_tag.text = str(pokemon.Special_Attack, "/" , pokemon.Max_Special_Attack)
	def_tag.text = str(pokemon.Defense, "/" , pokemon.Max_Defense)
	sp_def_tag.text = str(pokemon.Special_Defense, "/" , pokemon.Max_Special_Defense)
	spd_tag.text = str(pokemon.Speed, "/" , pokemon.Max_Speed)
