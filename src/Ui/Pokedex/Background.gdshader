shader_type canvas_item;

// Uniforms
uniform sampler2D base_texture : source_color; // Input texture for average color
uniform sampler2D noise_texture : source_color; // Noise texture for mask
uniform float tint_strength : hint_range(0.0, 1.0) = 0.2; // Controls how strong the tint is
uniform float noise_scale : hint_range(0.1, 1) = 1.0; // Controls the scale of the noise pattern
uniform float noise_intensity : hint_range(0.0, 1.0) = 0.3; // Controls the strength of the noise effect

// Function to compute average color from texture
vec3 compute_average_color(sampler2D tex) {
    vec3 total_color = vec3(0.0);
    float total_alpha = 0.0;
    int samples = 0;
    
    // Sample texture at multiple points
    for (float u = 0.0; u < 1.0; u += 0.05) {
        for (float v = 0.0; v < 1.0; v += 0.05) {
            vec4 sample = texture(tex, vec2(u, v));
            total_color += sample.rgb * sample.a;
            total_alpha += sample.a;
            samples++;
        }
    }
    
    if (total_alpha > 0.0) {
        return total_color / total_alpha;
    } else {
        return vec3(1.0); // Default to white if no opaque pixels
    }
}

void fragment() {
    // Compute the average color from the base texture
    vec3 avg_color = compute_average_color(base_texture);
    
    // Get the base color of the ColorRect
    vec3 base_color = COLOR.rgb;
    
    // Sample the noise texture
    float noise_value = texture(noise_texture, UV * noise_scale).r; // Use red channel for grayscale
    
    // Adjust tint strength with noise for a textured effect
    float modulated_tint = tint_strength * (1.0 + noise_value * noise_intensity - noise_intensity * 0.5);
    
    // Blend the base color with the average color
    vec3 final_color = mix(base_color, avg_color, modulated_tint);
    
    // Output the tinted color, fully opaque
    COLOR = vec4(final_color, 1.0);
}