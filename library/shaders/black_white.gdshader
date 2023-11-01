shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform float threshold: hint_range(0.0, 1.0, 0.01);

void fragment() {
	COLOR = texture(screen_tex, SCREEN_UV);
	float avg = (COLOR.r + COLOR.g + COLOR.b) * 0.33333333;
	avg = step(threshold, avg);
	COLOR = vec4(avg, avg, avg, 1.0);
}
