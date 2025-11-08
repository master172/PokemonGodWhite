extends TabContainer

const TYPE_BACKGROUND = preload("res://src/Ui/Reusable/type_background.tscn")

@onready var types: GridContainer = $About/Weaknesses/Types
@onready var pokedex_story: RichTextLabel = $About/Story/PokedexStory
@onready var biometrics: VBoxContainer = $About/Biometrics
@onready var stats: VBoxContainer = $About/Stats
@onready var scroll_container: ScrollContainer = $Moves/ScrollContainer

func present_info(pokemon:Pokemon):
	set_weaknesses(pokemon)
	pokedex_story.text = pokemon.description
	biometrics.set_data(pokemon)
	stats.set_data(pokemon)
	scroll_container.set_data(pokemon)

func reset_data():
	reset_weaknesses()
	biometrics.reset_data()
	
func reset_weaknesses():
	for i in types.get_children():
		i.queue_free()
		
func set_weaknesses(pokemon:Pokemon):
	var weaknesses = BattleManager.get_weaknesses(pokemon)
	print(weaknesses)
	for i in weaknesses:
		var T = TYPE_BACKGROUND.instantiate()
		types.add_child(T)
		T.set_type(i)
