shader_type canvas_item;

uniform vec4 inner_color : source_color = vec4(1.0, 0.5, 0.2, 1.0); // fill color (center)
uniform vec4 outer_color : source_color = vec4(0.2, 0.0, 0.0, 1.0); // edge color
uniform vec2 radius = vec2(0.4, 0.25);  // x/y radius (relative to rect)
uniform vec2 center = vec2(0.5, 0.5);   // center position (0–1)
uniform float softness = 0.0;           // smooth edges (0 = hard edge)
uniform bool gradient = true;           // enable gradient from center to edge

void fragment() {
    // Normalize coordinates so UV goes from 0..1
    vec2 uv = UV - center;

    // Scale UV so circle becomes an ellipse
    vec2 scaled = uv / radius;

    // Distance from center in elliptical space
    float dist = length(scaled);

    // Solid oval mask (softness for smooth edges)
    float mask = smoothstep(1.0, 1.0 - softness, dist);

    // Choose color (gradient or solid)
    vec4 color = gradient
        ? mix(inner_color, outer_color, clamp(dist, 0.0, 1.0))
        : inner_color;

    // Apply oval mask
    COLOR = color * mask;
}
