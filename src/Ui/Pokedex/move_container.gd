extends Panel

@onready var title: Label = $HBoxContainer/Title
@onready var type_background: Panel = $HBoxContainer/TypeBackground
@onready var cost: Label = $HBoxContainer/Cost

func set_data(move:BaseAction):
	title.text = move.name
	type_background.set_type(move.Type)
	cost.text =str(move.staminaCost)
