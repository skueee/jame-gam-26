// Color modulation

shader_type canvas_item;

uniform vec4 target_color : source_color;
uniform vec4 replacement_color : source_color;
uniform float tolerance = 0.1;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    // Check if the current pixel color matches the target color within a tolerance range
    if (distance(current_color.rgb, target_color.rgb) < tolerance) {
        COLOR = vec4(replacement_color.rgb, current_color.a);
    } else {
        COLOR = current_color;
    }
}