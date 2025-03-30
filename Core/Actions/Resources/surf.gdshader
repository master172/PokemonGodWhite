shader_type canvas_item;

uniform float wave_speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_strength : hint_range(0.01, 0.2) = 0.05;
uniform float wave_frequency : hint_range(1.0, 10.0) = 5.0;
uniform float ripple_speed : hint_range(0.1, 5.0) = 2.0;
uniform float ripple_strength : hint_range(0.01, 0.2) = 0.05;
uniform float ripple_frequency : hint_range(1.0, 10.0) = 5.0;
uniform float shoreline_radius : hint_range(0.1, 1.5) = 1.0; // Where the shoreline appears
uniform float shoreline_thickness : hint_range(0.01, 0.2) = 0.05; // Sharpness of the white border
uniform vec2 center = vec2(0.5, 0.5); // Origin of the ripple effect
uniform float tiling : hint_range(1.0, 10.0) = 5.0; // Texture tiling multiplier
uniform float alpha : hint_range(0.0, 1.0) = 1.0; // Transparency control for visible parts

void fragment() {
    vec2 uv = UV;
    
    // Infinite Tiling
    vec2 tiled_uv = fract(uv * tiling);
    
    // Compute distance from center
    float dist = distance(uv, center);

    // Wave distortion (horizontal movement)
    float wave = sin(uv.y * wave_frequency + TIME * wave_speed) * wave_strength;

    // Ripple effect (circular waves moving outward)
    float ripple = sin(dist * ripple_frequency - TIME * ripple_speed) * ripple_strength;

    // Apply wave + ripple distortion
    tiled_uv.x += wave + ripple;

    // Shoreline effect (sharp white border)
    float shoreline = smoothstep(shoreline_radius, shoreline_radius - shoreline_thickness, dist);

    // Sample the texture with the distorted UVs
    vec4 tex_color = texture(TEXTURE, tiled_uv);
    
    // Apply abrupt transition: shoreline = white, water = normal
    vec4 final_color = mix(vec4(1.0), tex_color, shoreline);

    // Anything outside the shoreline becomes fully transparent
    float alpha_mask = smoothstep(shoreline_radius + shoreline_thickness, shoreline_radius, dist);
    final_color.a *= alpha_mask * alpha; // Apply user-controlled transparency

    COLOR = final_color;
}
