extends Node2D

@onready var following_pokemon = $pokemon
@onready var reaction_creator = $ReactionCreator

var steps_covered:int:
	set(value):
		steps_covered = value
		if steps_covered >= 255:
			steps_covered = 0
			update_friendship()
		if steps_covered < 0:	
			steps_covered = 0
	get:
		return steps_covered

var HashMap = {
	Vector2(0,-1):Vector2(0,8),
	Vector2(0,1):Vector2(0,-24),
	Vector2(-1,0):Vector2(16,-8),
	Vector2(1,0):Vector2(-16,-8)
}

func _ready():
	visible = false
	global_position -= Vector2(0,16)
	Dialogic.connect("signal_event",handle_event)

func set_seeable():
	visible = true
	
func change_position(Position,Speed,Direction):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Position,Speed)
	await tween.finished
	update_direction(Direction)

func set_direction(Direction):
	await self.ready
	update_direction(Direction)
	
func update_direction(Direction):
	following_pokemon.set_direction(Direction)
	Utils.get_player().poke_pos = self.global_position
	Utils.get_player().pokeDirection = Direction

func change_position_to_ledge(Position,Speed,Direction):
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position",Position,Speed)
	await tween.finished
	update_direction(Direction)

func update_pokemon():
	following_pokemon.update()

func _interact():
	Dialogic.VAR.OverWorld.Pokemon = following_pokemon.pokemon.Nick_name
	Dialogic.VAR.OverWorld.Response = reaction_creator.get_default_response(following_pokemon.pokemon)
	Utils.get_player().set_physics_process(false)
	Dialogic.start("DefaultOverworld")

func handle_event(Sign:String):
	if Sign == "Finished":
		await get_tree().create_timer(0.1).timeout
		Utils.get_player().set_physics_process(true)

func update_friendship():
	var rng = RandomNumberGenerator.new()
	var coin_flip = rng.randi() % 2
	if coin_flip == 0:
		following_pokemon.pokemon.add_friendship(1)