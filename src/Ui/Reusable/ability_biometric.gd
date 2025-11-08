extends Panel
class_name AbilityBiometric

@onready var data: Label = $DataContainer/Data

func set_data(value:ability):
	data.text = value.Name
