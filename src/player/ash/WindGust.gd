extends CanvasLayer

@export var min_time :int = 0
@export var max_time :int = 10

@export var can_fire:bool = true

var Rng = RandomNumberGenerator.new()

@onready var timer = $Timer

const windGust = preload("res://src/Environment/Effects/WindGusts/WindGust.tscn")
const windGust1 = preload("res://src/Environment/Effects/WindGusts/WindGust1.tscn")
const windGust2 = preload("res://src/Environment/Effects/WindGusts/WindGust2.tscn")
const windGust3 = preload("res://src/Environment/Effects/WindGusts/WindGust3.tscn")

var wind_gusts :Array = [windGust,windGust1,windGust2,windGust3]

func _ready():
	if can_fire == true:

		start_gusts()

func start_gusts():
	
	timer.start(calc_rand_time())

	
func _on_timer_timeout():

	for i in range(generate_rand_gusts()):

		add_child(wind_gusts[Rng.randi() % wind_gusts.size()].instantiate())
		await get_tree().create_timer(get_offset_time()).timeout
	start_gusts()

func get_offset_time():
	return Rng.randi_range(0,5)
	
func generate_rand_gusts():
	
	var num = Rng.randi_range(0,self.get_child_count())
	return num

func calc_rand_time():
	return Rng.randi_range(min_time,max_time)
