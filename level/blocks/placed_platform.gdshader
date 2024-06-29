shader_type canvas_item;

uniform vec4 top_left_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bottom_right_color = vec4(0.8, 0.7, 0.5, 1.0);

void fragment() {
    vec2 t = UV;
    vec4 gradient_color = mix(top_left_color, bottom_right_color, (t.x + t.y) / 2.0);
    COLOR = gradient_color;
}