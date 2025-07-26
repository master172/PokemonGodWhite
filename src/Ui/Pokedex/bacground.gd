extends ColorRect


func set_background(pokemon:Pokemon):
	var mat:ShaderMaterial= self.material
	mat.set_shader_parameter("base_texture",pokemon.get_front_sprite())
	var noise_texture :NoiseTexture2D= mat.get_shader_parameter("noise_texture")
	var noise :Noise = noise_texture.noise
	noise.seed = randi()
