extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var GrassStepEfect = preload("res://Libraries/Grass/grass_step_effect.tscn")

var player_inside:bool = false
var grass_overlay : Node2D = null

@onready var stepped_grass = preload("res://Libraries/Grass/stepped_effect.tscn")

@export var EncounterRate :int = 33


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Utils.get_player()
	if player != null:
		player.connect("player_moving_signal",player_exiting_grass)
		player.connect("player_stopped_signal",player_in_grass)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_in_grass():
	if player_inside == true:
		var grass_step_effect = GrassStepEfect.instantiate()
		self.add_child(grass_step_effect)

		grass_overlay = stepped_grass.instantiate()
		grass_overlay.global_position = self.global_position + Vector2(0,16)
		grass_overlay.z_index = 0
		if Utils.get_scene_manager() != null:
			Utils.get_scene_manager().current_scene.get_child(0).add_child(grass_overlay)

		if Utils.can_encounter == true:
			check_encounter()


func player_exiting_grass():
	player_inside = false
	if is_instance_valid(grass_overlay):
		grass_overlay.queue_free()

func _on_area_2d_body_entered(body):
	player_inside = true
	animation_player.play("stepped")

func check_encounter():
	if Utils.get_scene_manager() != null:
		if encounter() == true:
			var pokemon = get_encounter_pokemon()

			if pokemon == null:
				return
			if talisman_attuned(pokemon):
				return
			BattleManager.current_ai_level = 0
			Utils.get_scene_manager().transition_to_battle_scene(pokemon)
			Utils.get_player().change_animation(false)

func talisman_attuned(pokemon:game_pokemon):
	if Utils.talisman_active == false:
		return false

	var level:int = 0
	for i :game_pokemon in AllyPokemon.get_party_pokemons():
		level += i.level

	if level >= pokemon.level:
		return true

	return false

func get_encounter_pokemon():
	var Rng = RandomNumberGenerator.new()
	var scene = Utils.get_scene_manager().get_current_scene()
	var encounter_pokemon = scene.get_encounter_pokemon()

	if encounter_pokemon == null:
		return null

	var poke_data = [encounter_pokemon,Rng.randi_range(scene.min_level,scene.max_level)]
	var pokemon = game_pokemon.new(poke_data[0],poke_data[1])
	return pokemon

func encounter():
	var Rng = RandomNumberGenerator.new()
	Rng.randomize()
	var random_encounter = randi_range(0,100)
	if random_encounter <= EncounterRate:
		return true

	return false
