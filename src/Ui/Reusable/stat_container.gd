extends HBoxContainer

@onready var title: Label = $Title
@onready var value_label: Label = $Value
@onready var progress_bar: ProgressBar = $ProgressBar

@export_enum (
	"Hp",
	"Attack",
	"Defense",
	"Speed",
	"Sp_Attack",
	"Sp_Defense",
	"None"
)var default_stat :String = "None"

func _ready() -> void:
	if default_stat != null:
		set_stat(default_stat)
		
func set_stat(value:String,pokemon:Pokemon = null):
	var stat_dict :Dictionary = {
		"Hp":pokemon.Base_Health,
		"Attack":pokemon.Base_Attack,
		"Defense":pokemon.Base_Defense,
		"Speed":pokemon.Base_Speed,
		"Sp_Attack":pokemon.Special_Base_Attack,
		"Sp_Defense":pokemon.Special_Base_Defense
	}
	if not pokemon == null:
		var val = stat_dict[value]
		value_label.text = val
		progress_bar.value = val
	title.text = value
