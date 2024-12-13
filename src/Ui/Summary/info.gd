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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _display(pokemon:game_pokemon):
	level.text = str(pokemon.level)
	Name.text = pokemon.Nick_name
	poke.texture = pokemon.Base_Pokemon.Front
	species.text = pokemon.Base_Pokemon.Name
	dex_no.text = str(pokemon.Base_Pokemon.Id)
	exp_points.text = str(pokemon.exp)
	gender.frame = pokemon.gender
	to_next_level.text = str(pokemon.exp_to_next_level)
	exp_bar.min_value = pokemon.exp_to_current_level
	exp_bar.max_value = pokemon.exp_to_next_level
	exp_bar.value = pokemon.exp
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
