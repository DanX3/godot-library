shader_type canvas_item;

uniform float time_scale = 1.0;
uniform sampler2D screen_texture: hint_screen_texture;
uniform sampler2D noise_tex : repeat_enable, filter_nearest;
uniform float water_opacity: hint_range(0.0, 1.0, 0.01);
uniform float distortion: hint_range(0.0, 1.0, 0.001);

void fragment() {
	vec4 water = texture(TEXTURE, UV);
	vec2 noise = distortion * (2.0 * texture(noise_tex, time_scale * TIME + SCREEN_UV).rg - 1.0);
	vec4 screen = texture(screen_texture, SCREEN_UV + noise);
	COLOR = mix(water, screen, 1.0 - water_opacity);
}


