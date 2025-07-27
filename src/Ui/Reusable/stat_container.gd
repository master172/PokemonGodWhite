extends Panel

@onready var title: Label = $VBoxContainer/Title
@onready var value_label: Label = $VBoxContainer/Value
@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar


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
		set_stat(null,default_stat)
		
func set_stat(pokemon:Pokemon = null,value:String = default_stat):
	if not pokemon == null:
		var stat_dict :Dictionary = {
			"Hp":pokemon.Base_Health,
			"Attack":pokemon.Base_Attack,
			"Defense":pokemon.Base_Defense,
			"Speed":pokemon.Base_Speed,
			"Sp_Attack":pokemon.Special_Base_Attack,
			"Sp_Defense":pokemon.Special_Base_Defense
		}
		var val = stat_dict[value]
		value_label.text = str(val)
		progress_bar.value = val
	title.text = value
