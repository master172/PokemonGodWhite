extends Panel

@onready var data: Label = $DataContainer/Data

func set_data(value:ability):
	data.text = value.Name
