shader_type canvas_item;

uniform vec4 inner_color : source_color = vec4(1.0, 0.6, 0.2, 1.0); // center color
uniform vec4 outer_color : source_color = vec4(0.1, 0.0, 0.2, 0.0); // edge color
uniform float radius = 0.4;   // circle radius (0–0.5 recommended)
uniform float softness = 0.02; // smooth edge falloff
uniform float noise_strength = 0.1; // how strong the noise effect is
uniform float noise_scale = 6.0; // frequency of the noise

// Simple 2D noise function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    // Normalize coordinates to -1..1 centered
    vec2 uv = (UV - 0.5) * 2.0;
    float dist = length(uv);

    // Compute circular mask
    float circle = smoothstep(radius + softness, radius - softness, dist);

    // Generate subtle noise
    float n = noise(UV * noise_scale) * 2.0 - 1.0;
    dist += n * noise_strength * (1.0 - dist / radius);

    // Gradient color based on distance
    vec4 col = mix(inner_color, outer_color, smoothstep(0.0, radius, dist));

    // Apply circle mask
    COLOR = col * circle;
}
