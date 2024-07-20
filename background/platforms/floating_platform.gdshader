shader_type canvas_item;

uniform vec2 corner_size = vec2(0.0, 0.3);
uniform float smoothness : hint_range(0.0, 1.0) = 0.25;
uniform float wave_height : hint_range(0.0, 0.5) = 0.1;
uniform float wave_frequency = 5.0;
uniform float wave_speed = 1.0;
uniform vec3 left_color : source_color = vec3(0.2, 0.15, 0.1);
uniform vec3 right_color : source_color = vec3(0.1, 0.05, 0.0);

void fragment() {
    vec2 uv = vec2(1.0, 1.0) - UV;
    
    float wave = wave_height * sin(wave_frequency * UV.x + TIME * wave_speed);
    
    vec2 wave_uv = vec2(uv.x, uv.y + wave);
    
    vec2 corner_distance = smoothstep(
        corner_size - smoothness,
        corner_size + smoothness,
        wave_uv
    );
    
    float corner_mask =corner_distance.y;
    
    float right_fade = smoothstep(0.0, 1.0, UV.x);
    
    COLOR.a *= corner_mask;
    
    vec3 color = mix(left_color, right_color, right_fade);
    
    COLOR.rgb = color;
}