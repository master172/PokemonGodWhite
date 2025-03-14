extends TextureRect

@onready var level = $"../presisting/Level"
@onready var Name = $"../presisting/Name"
@onready var item = $"../presisting/Item"
@onready var what = $"../presisting/What"
@onready var ball_caught = $"../presisting/BallCaught"
@onready var gender = $"../presisting/Gender"
@onready var poke = $"../presisting/Pokemon"
@onready var info = $Info
@onready var species = $Info/Species/Species
@onready var dex_no = $Info/DexNo/DexNo
@onready var ot = $Info/Ot/Ot
@onready var pokemon_id = $Info/PokemonID/PokemonID
@onready var exp_points = $Info/ExpPoints/ExpPoints
@onready var to_next_level = $Info/ToNextLevel/ToNextLevel
@onready var type = $Info/Type
@onready var type_1 = $Info/Type/Type1
@onready var type_2 = $Info/Type/Type2
@onready var exp_bar = $ExpBar

var type_to_frame:Dictionary = {
	"Normal":0,
	"Fighting":1,
	"Flying":2,
	"Poison":3,
	"Ground":4,
	"Rock":5,
	"Bug":6,
	"Ghost":7,
	"Steel":8,
	"Fire":9,
	"Water":10,
	"Grass":11,
	"Electric":12,
	"Psychic":13,
	"Ice":14,
	"Dragon":15,
	"Dark":16,
	"Fairy":17,
	"NONE":18
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _display(pokemon:game_pokemon):
	level.text = str(pokemon.level)
	Name.text = pokemon.Nick_name
	poke.texture = pokemon.Base_Pokemon.Front
	species.text = pokemon.Base_Pokemon.Name
	dex_no.text = str(pokemon.Base_Pokemon.Id)
	pokemon_id.text = get_file_name_no_extension(pokemon.nature)
	exp_points.text = str(pokemon.exp)
	gender.frame = pokemon.gender
	to_next_level.text = str(pokemon.exp_to_next_level)
	exp_bar.min_value = pokemon.exp_to_current_level
	exp_bar.max_value = pokemon.exp_to_next_level
	exp_bar.value = pokemon.exp
	set_type(pokemon)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_type(pokemon:game_pokemon):
	type_1.frame = type_to_frame[pokemon.Base_Pokemon.Type1]
	type_2.frame = type_to_frame[pokemon.Base_Pokemon.Type2]

func get_file_name_no_extension(resource: Nature) -> String:
	if resource.resource_path != "":
		return resource.resource_path.get_file().get_basename()
	return "Unnamed Resource"
