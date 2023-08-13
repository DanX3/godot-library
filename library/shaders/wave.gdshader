shader_type canvas_item;

uniform float speed = 1.0;
uniform float period = 1.0;
uniform vec2 direction = vec2(0.01, 0.01);
uniform sampler2D screen_tex: hint_screen_texture;

void fragment() {
	vec2 uv = fract(UV + direction * vec2(
		cos(speed * TIME + period * (2.0 * UV.y - 1.0)), 
		cos(speed * TIME + period * (2.0 * UV.x - 1.0))));
	COLOR = texture(screen_tex, uv);
}
