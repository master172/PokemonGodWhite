extends Resource
class_name trigger

@export_enum("Level", "Stone", "Trade") var character_class: int = 0

@export var evolving_level:int = 16
@export var evolving_stone:EvolutionStone = null

@export var NextPokemon:Pokemon
