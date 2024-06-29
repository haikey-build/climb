shader_type canvas_item;

uniform vec2 cutoffs[5];
uniform float offset_multipliers[5]; // New uniform for offset multipliers

void fragment() {
    float running_a = 0.0;
    float running_b = 0.0;
    float y = 1.0 - UV.y * 2.0;

    for (int i = 0; i < 5; i++) {
        if (y > running_a) {
            running_a += cutoffs[i][0] + sin(TIME * offset_multipliers[i]) * offset_multipliers[i]; 
            running_b += cutoffs[i][1] + sin(TIME * offset_multipliers[i]) * offset_multipliers[i];
        } else {
            break;
        }
    }

    if (y + running_b > UV.x) {
        COLOR.a = 0.0;
    } else {
        COLOR.a = 1.0;
    }
}
