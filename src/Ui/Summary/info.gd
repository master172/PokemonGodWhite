extends TextureRect

@onready var level = $Level
@onready var Name = $Name
@onready var item = $Item
@onready var what = $What
@onready var ball_caught = $BallCaught
@onready var gender = $Gender
@onready var poke = $Pokemon
@onready var info = $Info
@onready var label = $Info/Label
@onready var species = $Info/Label/Species/Species
@onready var dex_no = $Info/Label/DexNo/DexNo
@onready var ot = $Info/Label/Ot/Ot
@onready var pokemon_id = $Info/Label/PokemonID/PokemonID
@onready var exp_points = $Info/Label/ExpPoints/ExpPoints
@onready var to_next_level = $Info/Label/ToNextLevel/ToNextLevel
@onready var type = $Info/Label/Type
@onready var type_1 = $Info/Label/Type/Type1
@onready var type_2 = $Info/Label/Type/Type2
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
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
