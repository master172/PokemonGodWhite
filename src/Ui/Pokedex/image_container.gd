extends Control


@onready var image: TextureRect = $Image
@onready var gradient: ColorRect = $Image/Gradient
@onready var back: ColorRect = $Image/Back


func set_image(texture:Texture2D):
	image.texture = texture
	var mat :ShaderMaterial = gradient.material
	mat.set_shader_parameter("base_texture", texture)
	mat = back.material
	mat.set_shader_parameter("base_texture",texture)
