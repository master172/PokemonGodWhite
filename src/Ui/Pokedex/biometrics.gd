extends VBoxContainer

const ABILITY_BIOMETRIC = preload("res://src/Ui/Reusable/AbilityBiometric.tscn")

@onready var grid_container: GridContainer = $GridContainer
@onready var height: Panel = $GridContainer/Height
@onready var weight: Panel = $GridContainer/Weight

func set_data(pokemon:Pokemon):
	height.set_data(pokemon)
	weight.set_data(pokemon)
	for i in pokemon.Ability:
		var A = ABILITY_BIOMETRIC.instantiate()
		grid_container.add_child(A)
		A.set_data(i)
