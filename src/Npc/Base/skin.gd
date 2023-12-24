extends Sprite2D

@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer

@onready var anim_state = animation_tree.get("parameters/playback")

func _ready():
	var parent = get_parent()
	parent.TrainerSkin = self
	if parent.has_method("GetTrainerResource"):
		var resource = parent.GetTrainerResource()
		if resource == null:
			return
		texture = resource.sprite

func look(facDir:Vector2):
	anim_state.travel("Idle")
	animation_tree.set("parameters/Idle/blend_position",facDir)
