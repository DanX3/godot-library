shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D noise_color;
uniform vec4 modulate: source_color;
uniform float reflection: hint_range(0.0, 1.0, 0.01);
uniform float fade: hint_range(0.0, 2.0) = 1.0;
uniform float amplitude = 1;
uniform float speed = 1.0;

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
	uv += 0.01 * amplitude * distort(noise_color, UV, speed * TIME);

	vec4 screenTex = texture(screen_texture, uv);
	float reflectFactor = max(0.0, reflection - UV.y * fade);
	// prevent sampling from outside the screen texture
	reflectFactor -= (1.0 - step(0.0, uv.y)) * reflectFactor;
	COLOR = (1.0 - reflectFactor) * modulate + reflectFactor * screenTex;

	// applying mask from texture
	COLOR.a = texture(TEXTURE, UV).a;
}
