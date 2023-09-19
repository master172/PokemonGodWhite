extends Resource
class_name player_data

@export var pos :Vector2 = Vector2(0,0)
@export var input_dir :Vector2 = Vector2(0,0)
@export var is_cycling:bool = false
@export var is_surfing:bool = false
@export var playerState:int = 0
@export var pokemon_following:bool = false
@export var can_pokemon_follow:bool = true
@export var facingDirection:int = 0
@export var pokemonPos:Vector2 = Vector2(0,0)

func change_poke_pos(value:Vector2):
	pokemonPos = value
	
func change_input_dir(value:Vector2):
	input_dir = value
	
func change_pos(value:Vector2):
	pos = value

func change_cycling(value:bool):
	is_cycling = value

func change_surfing(value:bool):
	is_surfing = value

func change_playerState(value:int):
	playerState = value

func change_pokemon_following(value:bool):
	pokemon_following = value

func change_can_pokemon_follow(value:bool):
	can_pokemon_follow = value

func change_facing_direction(value:int):
	facingDirection = value
