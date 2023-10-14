extends Action

@export var attack_pos := Vector2(0,0)

@onready var beam = $Beam
@onready var electric_1 = $Electric1
@onready var electric_2 = $Electric2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _physics_process(delta):
#	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
#		attack_pos = get_global_mouse_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	beam.look_at(attack_pos)
	beam.scale.x = (self.global_position.distance_to(attack_pos))/128
	electric_2.global_position = attack_pos
