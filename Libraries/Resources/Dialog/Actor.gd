extends Resource

class_name Actor

enum Actor_type {
	None,
	System,
	Speaker,
	Listner
}

@export var actor_type:Actor_type = 0

@export var sprite_normal :Texture2D
@export var sprite_happy :Texture2D
@export var sprite_Angered :Texture2D

enum Mood {
	Normal,
	Happy,
	Angered
}

@export var mood:Mood = 0

func get_sprite():
	if mood == 0:
		return sprite_normal
	elif mood == 1:
		return sprite_happy
	elif mood == 2:
		return sprite_Angered

func get_actor_type():
	return actor_type
