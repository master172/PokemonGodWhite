extends Control

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var texture_rect: TextureRect = $TextureRect

signal done
signal starting

var nick_name:String = ""
var message:String = ""

func _ready() -> void:
	Dialogic.signal_event.connect(on_signal)
	
func celebrate(gift:WonderGift):
	emit_signal("starting")
	nick_name = gift.pokemon.Nick_name
	message = gift.message
	texture_rect.texture = gift.pokemon.Base_Pokemon.get_front_sprite()
	gpu_particles_2d.restart()

func on_signal(Sign:String):
	if Sign == "GiftingDone":
		emit_signal("done")

func _on_gpu_particles_2d_finished() -> void:
	Dialogic.VAR.Gifting.NickName = nick_name
	Dialogic.VAR.Gifting.Message = message
	Dialogic.start("regular")
