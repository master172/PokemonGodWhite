shader_type canvas_item;

uniform vec2 position = vec2(0); // Global position of the sprite
uniform vec2 scale = vec2(1); // Scale of the sprite
uniform vec2 offset = vec2(0); // Offset in pixels

uniform bool regionEnabled = false; // Enable Sprite Region
uniform vec2 regionPosition = vec2(0); // Region Sprite Position
uniform vec2 regionSize = vec2(16); // Region Sprite Size

void fragment() {
	vec2 uv = UV + (position + offset) * TEXTURE_PIXEL_SIZE / scale;
	if (regionEnabled) {
		uv -= regionPosition * TEXTURE_PIXEL_SIZE;
		uv = mod(uv * scale, regionSize * TEXTURE_PIXEL_SIZE) + regionPosition * TEXTURE_PIXEL_SIZE;
	}
	else {
		uv = mod(uv * scale, 1.0);
	}

	COLOR = texture(TEXTURE, uv);
}