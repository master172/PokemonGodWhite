extends Resource

class_name Pokemon

@export_group("general")


@export var Name:String = ""
@export var Id :int = 0


@export_enum(
	"Normal",
	"Fighting",
	"Flying",
	"Poison",
	"Ground",
	"Rock",
	"Bug",
	"Ghost",
	"Steel",
	"Fire",
	"Water",
	"Grass",
	"Electric",
	"Psychic",
	"Ice",
	"Dragon",
	"Dark",
	"Fairy",
	) var Type1:String = "Normal"

@export_enum(
	"Normal",
	"Fighting",
	"Flying",
	"Poison",
	"Ground",
	"Rock",
	"Bug",
	"Ghost",
	"Steel",
	"Fire",
	"Water",
	"Grass",
	"Electric",
	"Psychic",
	"Ice",
	"Dragon",
	"Dark",
	"Fairy",
	"NONE"
	) var Type2:String = "NONE"

@export_enum(
	"Slow",
	"MediumSlow",
	"MediumFast",
	"Fast",
	"Erratic",
	"Fluctuating"
)var leveleing_type:int = 2

@export var Ability:Array[ability] = []
 
@export_group("personality")
@export var default_friendship:int = 70

@export_group("egg_groups")
@export_enum(
	"Monster",
	"Fairy",
	"Human_like",
	"Field",
	"Flying",
	"Dragon",
	"Bug",
	"Water1",
	"Water2",
	"Water3",
	"Grass",
	"Amorphous",
	"Mineral",
	"Ditto",
	"No_eggs_discovered"
	)var Egg_group0:String = "Monster"

@export_enum(
	"Monster",
	"Fairy",
	"Human_like",
	"Field",
	"Flying",
	"Dragon",
	"Bug",
	"Water1",
	"Water2",
	"Water3",
	"Grass",
	"Amorphous",
	"Mineral",
	"Ditto",
	"No_eggs_discovered"
	)var Egg_group1:String = "Human_like"


@export_group("Sprites")
@export var Front:Texture2D
@export var Icon:Texture2D
@export var Overworld:Texture2D


@export_group("statSheet")
@export_subgroup("Base")
@export var Base_Health :int
@export var Base_Attack :int
@export var Base_Defense :int
@export var Special_Base_Attack :int
@export var Special_Base_Defense :int
@export var Base_Speed :int

var natures :Array = [
	"res://Resources/PokeMon/Natures/Hardy.tres",
	"res://Resources/PokeMon/Natures/Lonely.tres",
	"res://Resources/PokeMon/Natures/Brave.tres",
	"res://Resources/PokeMon/Natures/Adamant.tres",
	"res://Resources/PokeMon/Natures/Naughty.tres",
	"res://Resources/PokeMon/Natures/Bold.tres",
	"res://Resources/PokeMon/Natures/Docile.tres",
	"res://Resources/PokeMon/Natures/Relaxed.tres",
	"res://Resources/PokeMon/Natures/Impish.tres",
	"res://Resources/PokeMon/Natures/Lax.tres",
	"res://Resources/PokeMon/Natures/Timid.tres",
	"res://Resources/PokeMon/Natures/Hasty.tres",
	"res://Resources/PokeMon/Natures/Serious.tres",
	"res://Resources/PokeMon/Natures/Jolly.tres",
	"res://Resources/PokeMon/Natures/Naive.tres",
	"res://Resources/PokeMon/Natures/Modest.tres",
	"res://Resources/PokeMon/Natures/Mild.tres",
	"res://Resources/PokeMon/Natures/Quiet.tres",
	"res://Resources/PokeMon/Natures/Bashful.tres",
	"res://Resources/PokeMon/Natures/Rash.tres",
	"res://Resources/PokeMon/Natures/Calm.tres",
	"res://Resources/PokeMon/Natures/Gentle.tres",
	"res://Resources/PokeMon/Natures/Sassy.tres",
	"res://Resources/PokeMon/Natures/Careful.tres",
	"res://Resources/PokeMon/Natures/Quirky.tres"
]

@export_group("attacks")
@export var Actions:Array[BaseAction] = []
@export var TmActions:Array[BaseAction] = []
@export var EggActions:Array[BaseAction] = []

@export_group("battles")
@export var base_experience:int = 64

@export_subgroup("EV yields")
@export var Yield_Health :int = 0
@export var Yield_Attack :int = 0
@export var Yield_Defense :int = 0
@export var Yield_Special_Defense :int = 0
@export var Yield_Special_Attack :int = 0
@export var Yield_Speed :int = 0

@export_subgroup("catching")

@export_range(1,100) var catch_chance := 20


@export_group("evolution")
@export var evolutor:Evolutor = Evolutor.new()
@export_file("*.tres") var previous_pokemon:String = ""

@export_group("pokedex")
@export var Tag :String = ""
@export_multiline var description :String = ""
@export var height:int = 1
@export var weight:int = 10

func get_catch_rate():
	return catch_chance
	
func get_overworld_sprite():
	return Overworld

func get_icon_sprite():
	return Icon

func get_front_sprite():
	return Front
	
func get_Type1():
	return Type1

func get_Type2():
	return Type2
