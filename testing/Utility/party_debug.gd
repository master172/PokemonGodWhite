extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_debug_party():
	var ralts = load("res://Core/Pokemon/Ralts.tres")
	var Ralts:game_pokemon = game_pokemon.new(ralts,5,"Beta",1)
	
	var buneary = load("res://Core/Pokemon/Buneary.tres")
	var Buneary:game_pokemon = game_pokemon.new(buneary,5,"Gamma",1)
	
	var vaporeon = load("res://Core/Pokemon/Vaporeon.tres")
	var Vaporeon:game_pokemon = game_pokemon.new(vaporeon,5,"Delta",1)
	
	var fennekin = load("res://Core/Pokemon/Fennekin.tres")
	var Fennekin:game_pokemon = game_pokemon.new(fennekin,5,"Zeta",1)
	
	var gible = load("res://Core/Pokemon/Gible.tres")
	var Gible:game_pokemon = game_pokemon.new(gible,5,"Eta",1)
	
	var riolu = load("res://Core/Pokemon/Riolu.tres")
	var Riolu:game_pokemon = game_pokemon.new(riolu,5,"Epsilon",1)
	
	var pidgey = load("res://Core/Pokemon/Pidgey.tres")
	var Pidgey:game_pokemon = game_pokemon.new(pidgey,17,"Nu",1)
	
	var pidgeotto = load("res://Core/Pokemon/Pidgeotto.tres")
	var Pidgeotto:game_pokemon = game_pokemon.new(pidgeotto,5,"Theta",1)
	
	
	AllyPokemon.add_pokemon(Ralts)
	AllyPokemon.add_pokemon(Buneary)
	AllyPokemon.add_pokemon(Vaporeon)
	AllyPokemon.add_pokemon(Fennekin)
	AllyPokemon.add_pokemon(Gible)
	AllyPokemon.add_pokemon(Riolu)
	AllyPokemon.add_pokemon(Pidgeotto)
	AllyPokemon.add_pokemon(Pidgey)
	
func _on_button_pressed():
	add_debug_party()


func _on_button_2_pressed():
	AllyPokemon.all_heal()
