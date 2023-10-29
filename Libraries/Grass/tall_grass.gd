extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var GrassStepEfect = preload("res://Libraries/Grass/grass_step_effect.tscn")

var player_inside:bool = false
var grass_overlay : Sprite2D = null

const grass_overlay_texture = preload("res://assets/tallgrass/stepped_tall_grass.png")

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
		
		grass_overlay = Sprite2D.new()
		grass_overlay.texture = grass_overlay_texture
		grass_overlay.position
		grass_overlay.z_index = 2
		self.add_child(grass_overlay)
		
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
			Utils.get_scene_manager().transistion_to_battle_scene(pokemon)
			Utils.get_player().change_animation(false)

func get_encounter_pokemon():
	var Rng = RandomNumberGenerator.new()
	var scene = Utils.get_scene_manager().get_current_scene()
	var encounter_pokemon = scene.get_encounter_pokemon()
	var poke_data = [encounter_pokemon,Rng.randi_range(scene.min_level,scene.max_level)]
	return poke_data
	
func encounter():
	var Rng = RandomNumberGenerator.new()
	Rng.randomize()
	var random_encounter = randi_range(0,100)
	if random_encounter <= EncounterRate:
		return true
	
	return false
