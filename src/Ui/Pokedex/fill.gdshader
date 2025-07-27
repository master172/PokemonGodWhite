shader_type canvas_item;

// Uniforms
uniform sampler2D base_texture : source_color; // Input texture for dominant color
uniform float gradient_strength : hint_range(0.0, 1.0) = 0.5; // Controls gradient intensity
uniform float gradient_falloff : hint_range(0.1, 2.0) = 1.0; // Controls gradient spread
uniform float center_size : hint_range(0.0, 0.5) = 0.1; // Size of the central rectangular region
uniform float smoothness : hint_range(0.0, 1.0) = 0.3; // Controls smoothness of diagonal transitions

// Function to convert RGB to HSV
vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

// Function to compute the dominant color
vec3 compute_dominant_color(sampler2D tex) {
    float hue_histogram[6]; // Six hue ranges (0-60, 60-120, ..., 300-360 degrees)
    vec3 color_sums[6]; // Sum of RGB colors in each hue range
    int sample_counts[6]; // Number of samples in each hue range
    
    // Initialize arrays
    for (int i = 0; i < 6; i++) {
        hue_histogram[i] = 0.0;
        color_sums[i] = vec3(0.0);
        sample_counts[i] = 0;
    }
    
    // Sample texture to build hue histogram
    for (float u = 0.0; u < 1.0; u += 0.05) {
        for (float v = 0.0; v < 1.0; v += 0.05) {
            vec4 sample = texture(tex, vec2(u, v));
            if (sample.a > 0.0) { // Ignore transparent pixels
                vec3 hsv = rgb_to_hsv(sample.rgb);
                float hue = hsv.x * 360.0; // Convert to degrees
                int bin = int(hue / 60.0); // 6 bins (0-60, 60-120, ..., 300-360)
                if (bin >= 0 && bin < 6) {
                    hue_histogram[bin] += sample.a; // Weight by alpha
                    color_sums[bin] += sample.rgb * sample.a;
                    sample_counts[bin] += 1;
                }
            }
        }
    }
    
    // Find the bin with the most weight
    int max_bin = 0;
    float max_weight = hue_histogram[0];
    for (int i = 1; i < 6; i++) {
        if (hue_histogram[i] > max_weight) {
            max_weight = hue_histogram[i];
            max_bin = i;
        }
    }
    
    // Average the colors in the dominant hue bin
    if (sample_counts[max_bin] > 0 && hue_histogram[max_bin] > 0.0) {
        return color_sums[max_bin] / hue_histogram[max_bin];
    } else {
        return vec3(1.0); // Default to white if no valid pixels
    }
}

void fragment() {
    // Compute the dominant color from the texture
    vec3 dominant_color = compute_dominant_color(base_texture);
    
    // Calculate square distance (Chebyshev) from center (UV = 0.5, 0.5)
    vec2 centered_uv = abs(UV - vec2(0.5));
    float max_dist = max(centered_uv.x, centered_uv.y);
    float min_dist = min(centered_uv.x, centered_uv.y);
    
    // Smooth the distance to reduce diagonal intensity
    float smoothed_dist = mix(max_dist, max_dist * (1.0 - min_dist), smoothness);
    
    // Compute gradient factor (0 in central region, 1 at edges)
    float gradient_factor = clamp(pow((smoothed_dist - center_size) / (0.5 - center_size), gradient_falloff), 0.0, 1.0);
    
    // Compute alpha based on gradient factor
    float alpha = (1.0 - gradient_factor) * gradient_strength;
    
    // Output the dominant color with fading alpha
    COLOR = vec4(dominant_color, alpha);
}