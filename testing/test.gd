extends Node2D

@export var nature:Nature

var ranges = [-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6]
var array : Array = [1,4,"5",true,5.08]
# Called when the node enters the scene tree for the first time.

var current_multiplier :int = 1
func map_range(x: float) -> float:
	return (2.0) / (abs(x) + 2) if x <= 0 else (x+2)/2.0

# Example usage:
func _ready():
	var values = [-6, -5, -4 ,-3, -2, -1,  0, 1, 2, 3, 4, 5, 6]  # Test values from the input range
	for x in values:
		print("f(", x, ") = ", map_range(x))
	for i in range(0,7):
		current_multiplier += map_range(i)
		print("current_multiplier = ", current_multiplier)
