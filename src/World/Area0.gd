extends Node2D

@export var pokemons :Array[Pokemon] = []
@export var min_level :int
@export var max_level :int

# Called when the node enters the scene tree for the first time.
func _ready():
	Utils.Tilemap = get_node("%mainTilemap")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
