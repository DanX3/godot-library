shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_color;
uniform vec4 modulate: source_color;
uniform vec4 clear_color: source_color;
uniform float reflection: hint_range(0.0, 1.0, 0.01);
uniform float amplitude = 1;
uniform float time_scale = 1.0;

/// keep this parameter in sync with Node2D.scale property
uniform float scale = 1.0;

vec2 distort(sampler2D noise, vec2 uv, float time) {
	vec2 uv1 = uv + time * vec2(0.2, 0.1);
	vec2 uv2 = fract(uv + time * vec2(0.25, 0.4));
	vec4 noise1 = texture(noise, uv1);
	vec4 noise2 = texture(noise, uv2);
	vec4 offset = noise1 + noise2 - vec4(1.0);
	return offset.rg;
}

void fragment() {
	// computing pixel to reflect in screen resolution instead of UV
	vec2 uv = SCREEN_UV / SCREEN_PIXEL_SIZE;
	uv.y = uv.y - 2.0 * UV.y / TEXTURE_PIXEL_SIZE.y * scale;
	uv *= SCREEN_PIXEL_SIZE;

	// wave effect
	uv += 0.01 * amplitude * distort(noise_color, UV, time_scale * TIME);
	
	// texture sample
	COLOR = texture(screen_texture, uv);
	
	// modulate color
	COLOR = reflection * texture(screen_texture, uv) + (1.0 - reflection) * modulate;
	
	// applying mask from texture
//	COLOR.a = texture(TEXTURE, UV).r;
	
	// difference from clear color
	vec4 dcc = abs(texture(screen_texture, SCREEN_UV) - clear_color);
	float total_diff = dcc.r + dcc.g + dcc.b;
	COLOR.a = 1.0 - step(0.001, total_diff);
}
