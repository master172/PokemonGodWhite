extends Node2D

var playerData :player_data = player_data.new()

var save_file_path = "user://save/Player/"
var save_file_name = "PlayerSave.tres"

signal applying_done
# Called when the node enters the scene tree for the first time.
func _ready():
	verify_save_directory(save_file_path)

func verify_save_directory(path:String):
	DirAccess.make_dir_recursive_absolute(path)
# Called every frame. 'delta' is the elapsed time since the previous frame.

func save_data():
	ResourceSaver.save(playerData,save_file_path + save_file_name)

func load_data():
	if FileAccess.file_exists(save_file_path + save_file_name):
		playerData = ResourceLoader.load(save_file_path + save_file_name).duplicate(true)
	
func apply_data(player):
	if FileAccess.file_exists(save_file_path + save_file_name):
		player.position = playerData.pos
		player.input_direction = playerData.input_dir
		player.is_cycling = playerData.is_cycling
		player.is_surfing = playerData.is_surfing
		player.playerState = playerData.playerState
		player.pokemon_following = playerData.pokemon_following
		player.to_pokemon_follow = playerData.can_pokemon_follow
		player.facingDirection = playerData.facingDirection
		player.poke_pos = playerData.pokemonPos
		player.pokeDirection = playerData.pokeDirection
		emit_signal("applying_done")
