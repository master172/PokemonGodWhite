shader_type canvas_item;

// Uniforms
uniform sampler2D base_texture : source_color;
uniform float gradient_radius : hint_range(0.0, 1.0) = 0.5;
uniform float gradient_intensity : hint_range(0.0, 2.0) = 0.5;

// Function to compute average color from texture
vec3 compute_average_color(sampler2D tex) {
    vec3 total_color = vec3(0.0);
    float total_alpha = 0.0;
    int samples = 0;
    
    // Sample texture at multiple points
    for (float u = 0.0; u < 1.0; u += 0.1) {
        for (float v = 0.0; v < 1.0; v += 0.1) {
            vec4 sample = texture(tex, vec2(u, v));
            total_color += sample.rgb * sample.a;
            total_alpha += sample.a;
            samples++;
        }
    }
    
    if (total_alpha > 0.0) {
        return total_color / total_alpha;
    } else {
        return vec3(0.0);
    }
}

void fragment() {
    // Get the texture alpha to determine shape
    vec4 tex_color = texture(base_texture, UV);
    vec3 avg_color = compute_average_color(base_texture);
    
    // Calculate distance for gradient
    float dist = length(UV - 0.5);
    // Gradient only where texture is transparent and within radius
    float gradient_alpha = (1.0 - tex_color.a) * (1.0 - smoothstep(0.0, gradient_radius, dist)) * gradient_intensity;
    
    // Output only the gradient, everything else transparent
    COLOR = vec4(avg_color * gradient_alpha, gradient_alpha);
}