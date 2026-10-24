shader_type canvas_item;

uniform vec2 ellipse_scale = vec2(1.0, 1.0);
uniform float base_radius = 0.3;
uniform float noise_strength = 0.08;
uniform float noise_speed = 2.5;

uniform vec4 inner_color : source_color = vec4(0.0, 0.0, 1.0, 1.0);
uniform vec4 edge_color : source_color = vec4(0.6, 0.8, 1.0, 1.0);
uniform float border_thickness = 0.05;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    vec2 uv = (UV - vec2(0.5)) / ellipse_scale;
    float angle = atan(uv.y, uv.x);
    float dist = length(uv);
    
    vec2 noise_coord = vec2(cos(angle), sin(angle)) * 1.2 + vec2(TIME * noise_speed * 0.2);
    float n = noise(noise_coord);
    
    float dynamic_radius = base_radius + n * noise_strength;
    
    float blob_mask = smoothstep(dynamic_radius + 0.01, dynamic_radius - 0.01, dist);
    float border_mask = smoothstep(dynamic_radius - border_thickness + 0.01, dynamic_radius - border_thickness - 0.01, dist);
    
    vec4 final_color = inner_color;
    final_color = mix(final_color, edge_color, (1.0 - border_mask) * blob_mask);
    final_color.a *= blob_mask;
    
    COLOR = final_color;
}
