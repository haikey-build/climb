shader_type canvas_item;

const vec4 yellow = vec4(0.9, 0.7, 0.3, 1.0);
const vec4 red = vec4(0.9, 0.2, 0.3, 1.0);
const vec4 blue = vec4(0.2, 0.3, 0.9, 1.0);



void fragment() {
	if (UV.x > 0.5) {
		COLOR = red;
	} else {
		COLOR = yellow;
	}
}
