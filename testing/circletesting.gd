extends Node2D

var i :int= 0

var point_pos:Array[Vector2] = []

var attempt:int = 0
func _ready():
	while i <= 3141:
		point_pos.append(selection_mapping(400))
		i += 1
		
func selection_mapping(r:int):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	while true:
		var x = rng.randi_range(-r,r)
		var y = rng.randi_range(-r,r)
		if Vector2(x,y).distance_to(Vector2(0,0)) <= r:
			attempt = 0
			return Vector2(x,y)
			
func _draw():
	for point in point_pos:
		draw_circle(point,1,Color.RED)
