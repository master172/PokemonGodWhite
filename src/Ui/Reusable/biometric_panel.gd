extends Panel

@onready var title: Label = $DataContainer/Title
@onready var data: Label = $DataContainer/Data

var value_type:String = ""

func _ready() -> void:
	title.text = self.name
	value_type = title.text
	
func set_data(pokemon:Pokemon):
	data.text = str(pokemon.get(value_type.to_lower()))
