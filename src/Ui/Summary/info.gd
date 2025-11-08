extends ColorRect

@onready var species: Label = $Info/Main/Items/Species
@onready var dex_no: Label = $Info/Main/Items/DexNo
@onready var ot: Label = $Info/Main/Items/Ot
@onready var pokemon_id: Label = $Info/Main/Items/PokemonID
@onready var exp_points: Label = $Info/Main/Items/ExpPoints
@onready var to_next_level: Label = $Info/Main/Items/ToNextLevel
@onready var type_1: Panel = $Info/Main/Items/Types/Type1
@onready var exp_bar: ProgressBar = $Info/ExpContainer/ExpBar
@onready var type_2: Panel = $Info/Main/Items/Types/Type2

func _display(pokemon:game_pokemon):
	species.text = pokemon.Base_Pokemon.Name
	dex_no.text = str(pokemon.Base_Pokemon.Id)
	pokemon_id.text = get_file_name_no_extension(pokemon.nature)
	exp_points.text = str(pokemon.exp)
	to_next_level.text = str(pokemon.exp_to_next_level - pokemon.exp)
	exp_bar.min_value = pokemon.exp_to_current_level
	exp_bar.max_value = pokemon.exp_to_next_level
	exp_bar.value = pokemon.exp
	set_type(pokemon)

func set_type(pokemon:game_pokemon):
	type_1.set_type(pokemon.Base_Pokemon.Type1)
	type_2.set_type(pokemon.Base_Pokemon.Type2)

func get_file_name_no_extension(resource: Nature) -> String:
	if resource.resource_path != "":
		return resource.resource_path.get_file().get_basename()
	return "Unnamed Resource"
