extends Node

var Global_Variables :Dictionary= {}

var auto_moves:bool = false
var auto_evolve:bool = false

var move_management :bool = false

var steps_taken:int = 0:
	set(value):
		if value > 9999:
			value = 0
		steps_taken = value
	get:
		return steps_taken
