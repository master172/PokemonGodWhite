extends VBoxContainer

@onready var pokemon_texture: TextureRect = $Panel/Pokemon
@onready var Name: Label = $Name

func set_pokemon(pokemon:Pokemon) -> void:
	Name.text = pokemon.Name
	pokemon_texture.texture = pokemon.get_front_sprite()
