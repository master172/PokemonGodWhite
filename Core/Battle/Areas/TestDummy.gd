extends RigidBody2D

var health:int  = 200:
	set(new_value):
		health = new_value
		if health <= 0:
			queue_free()
	get:
		return health
