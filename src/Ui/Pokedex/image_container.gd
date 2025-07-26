extends Control


@onready var image: TextureRect = $Image
@onready var gradient: ColorRect = $Image/Gradient


func set_image(texture:Texture2D):
	image.texture = texture
	var mat :ShaderMaterial = gradient.material
	material.set_shader_parameter("base_texture", texture)
