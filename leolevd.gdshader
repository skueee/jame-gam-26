
shader_type canvas_item;

uniform float distortion : hint_range(0.0, 0.1) = 0.015;
uniform float glitch_speed : hint_range(0.0, 30.0) = 10.0;
uniform float color_shift : hint_range(0.0, 0.05) = 0.008;
uniform float red_blue_mix : hint_range(0.0, 1.0) = 0.6;

void fragment() {
    vec2 uv = UV;

    // Horizontal glitch bands
    float band = floor(uv.y * 35.0);
    float noise = fract(sin(band * 127.1 + floor(TIME * glitch_speed) * 311.7) * 43758.5453);

    // Only some bands glitch
    float glitch = step(0.75, noise);
    uv.x += (noise - 0.5) * distortion * glitch;

    // Subtle continuous wave distortion
    uv.x += sin(uv.y * 35.0 + TIME * 8.0) * distortion * 0.25;

    // Keep sampling inside the texture
    uv = clamp(uv, vec2(0.0), vec2(1.0));

    // Chromatic aberration
    float r = texture(TEXTURE, uv + vec2(color_shift, 0.0)).r;
    float g = texture(TEXTURE, uv).g;
    float b = texture(TEXTURE, uv - vec2(color_shift, 0.0)).b;

    // Use the ORIGINAL alpha to preserve sprite shape
    float alpha = texture(TEXTURE, UV).a;

    vec3 shifted = vec3(r, g * 0.35, b);

    // Blend between original and glitch colors
    vec3 original = texture(TEXTURE, uv).rgb;
    vec3 final_color = mix(original, shifted, red_blue_mix);

    COLOR = vec4(final_color, alpha);
}
