shader_type canvas_item;

const vec2 cutoffs[3] = vec2[](
	vec2(0.1, 0.05),
	vec2(0.3, 0.2),
	vec2(0.4, 0.1)
);


void fragment() {
	
	float sum_slices = 0.0;
	float sum_size_sliced = 0.0;
	
	float y = 1.0 - UV.y;
	
	for (int i = 0; i < 3; i++) {
		if (y > sum_slices) {
			sum_slices += cutoffs[i][0];
			sum_size_sliced += cutoffs[i][1];
		} else { break; }
	}
	
	if (y + sum_size_sliced > UV.x) {
		COLOR.a = 0.0;
	}

}
