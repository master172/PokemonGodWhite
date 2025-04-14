extends Control

var progress = []
var sceneName = "res://src/Game/scene_manager.tscn"
var scene_load_status = 0

@onready var progress_bar = $ProgressBar
@onready var rich_text_label = $ColorRect/Panel/RichTextLabel
@onready var animation_player = $AnimationPlayer

@export var Intro:Control
var tips = ["Don't forget to breathe very important",
"defeating opposing pokemon defeats them",
"currently no good tips avialable"]

var can_load:bool = true
func _ready():
	change_tip()

func load_game():
	load_game_data()
	ResourceLoader.load_threaded_request(sceneName)

func load_intro():
	AudioManager.switch_to_intro()
	can_load = false
	Intro.start()
	Intro.connect("done",_intro_done)
	load_game()

func _intro_done():
	can_load = true
	
func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress)
	progress_bar.value = floor(progress[0] * 100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		if can_load == true:
			var new_scene = ResourceLoader.load_threaded_get(sceneName)
			AudioManager.switch_to_exploration()
			get_tree().change_scene_to_packed(new_scene)
			#Global.load_data()


func change_tip():
	var item = tips[randi() % tips.size()]
	rich_text_label.text = item
	
func _on_tip_timer_timeout():
	animation_player.play("Fade")

func load_game_data():
	Utils.handle_load()
	Global.start_load()
	AllyPokemon.start_load()
	Inventory.start_load()
