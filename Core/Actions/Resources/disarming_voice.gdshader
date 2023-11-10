shader_type canvas_item;

uniform vec2 center;

uniform float force;
uniform float size;
uniform float blast;

uniform vec2 direction;
uniform float aperture : hint_range(0.0, 3.141516, 0.001);

uniform float red_offset : hint_range(0.0, 2.0, 0.001);
uniform float green_offset : hint_range(0.0, 2.0, 0.001);
uniform float blue_offset : hint_range(0.0, 2.0, 0.001);

uniform sampler2D SCREEN_TEXTURE :hint_screen_texture, filter_linear_mipmap;

vec2 scale(vec2 coord, vec2 scale) {
	return coord * scale;
}

void fragment() {
	float dist = distance(FRAGCOORD.xy, center);
	vec2 norm = normalize(FRAGCOORD.xy - center);

	float angle = acos(dot(normalize(vec2(-direction.x, direction.y)), -norm));
	float mask = cos((angle * 1.5707963268) / (aperture + .00001)) * step(angle, aperture) * force;

	float blast_mask = smoothstep(blast - size/2., blast, dist);
	float total_size = blast + (size / 2.);

	vec3 offsets = vec3(red_offset, green_offset, blue_offset);
	vec3 forces = offsets * mask * blast_mask;
	vec3 raw_eases = total_size * offsets;
	raw_eases = clamp(dist / raw_eases, vec3(0.), vec3(1.));
	vec3 easings = pow(raw_eases, forces);
	vec3 deforms = easings * dist;
	
	
	COLOR = vec4(
		texture(SCREEN_TEXTURE, scale(center + (deforms.r * norm), SCREEN_PIXEL_SIZE)).r,
		texture(SCREEN_TEXTURE, scale(center + (deforms.g * norm), SCREEN_PIXEL_SIZE)).g,
		texture(SCREEN_TEXTURE, scale(center + (deforms.b * norm), SCREEN_PIXEL_SIZE)).b,
		1.0);
}