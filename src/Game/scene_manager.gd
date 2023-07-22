extends Node2D

var next_scene = null

@onready var transition_player = $ScreenTranistion/AnimationPlayer
@onready var current_scene = $Current_scene
@onready var menu = $Menu/Menu

var player_location
var player_direction

enum Transition_Type {
	NEW_SCENE,
	PARTY_SCREEN,
	MENU_ONLY
}
var transition_type = Transition_Type.NEW_SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_current_scene():
	return current_scene.get_child(0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func transition_to_party_screen():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.PARTY_SCREEN
	
func transistion_exit_party_screen():
	transition_player.play("FadeToBlack")
	transition_type = Transition_Type.MENU_ONLY
	
func transition_to_scene(new_scene:String, spawn_location:Vector2, spawn_direction:Vector2):
	player_location = spawn_location
	player_direction = spawn_direction
	next_scene = new_scene
	transition_type = Transition_Type.NEW_SCENE
	transition_player.play("FadeToBlack")

func finished_fading():
	match transition_type:
		Transition_Type.NEW_SCENE:
			current_scene.get_child(0).queue_free()
			current_scene.add_child(load(next_scene).instantiate())
			
			var player = Utils.get_player()
			player.set_spawn(player_location,player_direction)
		
		Transition_Type.MENU_ONLY:
			menu.unload_party_screen()
		Transition_Type.PARTY_SCREEN:
			menu.load_party_screen()
			
	transition_player.play("FadeToNormal")
