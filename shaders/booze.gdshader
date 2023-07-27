shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform float amplitude = 1.0;


void fragment() {
	vec4 color = vec4(0.0);
	color += texture(screen_tex, fract(UV + amplitude * 0.01 * vec2(-0.5 * cos(TIME + PI), 0.5 * sin(TIME + 1.57))));
	color += texture(screen_tex, fract(UV + amplitude * 0.02 * vec2(0.2 * sin(0.5 * TIME), -0.2 * cos(2.0 * TIME + 0.1))));
	color += texture(screen_tex, fract(UV + amplitude * .02 * vec2(-0.75 * cos(TIME - PI), 0.5 * sin(-TIME))));
	color /= 3.0;
	color.a = 1.0;
	COLOR = color;
}
