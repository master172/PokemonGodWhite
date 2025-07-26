extends VBoxContainer


@onready var Name_label: Label = $NameContainer/Name
@onready var id: Label = $NameContainer/id

@onready var type_background: Panel = $TypeContainer/TypeBackground
@onready var type_background_2: Panel = $TypeContainer/TypeBackground2
@onready var image_container: Control = $ImageContainer


func present_info(pokemon:Pokemon):
	Name_label.text = pokemon.Name
	id.text = str(pokemon.Id)
	type_background.set_type(pokemon.Type1)
	type_background_2.set_type(pokemon.Type2)
	image_container.set_image(pokemon.get_front_sprite())
