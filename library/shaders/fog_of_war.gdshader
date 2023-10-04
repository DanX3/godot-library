shader_type canvas_item;

uniform float radius = 0.05;
uniform float timeScale = 1.0;
uniform sampler2D fogTexture;
uniform float fogScale = 0.1;

void fragment() {
	float timeScaled = TIME * timeScale;
	vec2 uv1 = UV + radius * vec2(cos(timeScaled), sin(-.75 * timeScaled));
	vec2 uv2 = UV + radius * vec2(-cos(1.2 * timeScaled), -sin(timeScaled));
	vec4 tex1 = texture(TEXTURE, uv1);
	vec4 tex2 = texture(TEXTURE, uv2);
	vec4 tex = 0.5 * (tex1 + tex2);
//	COLOR = vec4(0.0, 0.0, 0.0, 1.0 - tex.r);
	vec4 fog1 = texture(fogTexture, fract((sin(0.01 * timeScaled) + 2.0) * fogScale *  (UV + vec2(0.025 * timeScaled, -0.03 * timeScaled))));
	vec4 fog2 = texture(fogTexture, fract(fogScale *  (UV + vec2(-0.03 * timeScaled, 0.01 * timeScaled))));
	vec4 fog = 0.5 + 0.5 * (fog1 * fog2);
//	COLOR = vec4(0.0, 0.0, 0.0, 1.0 - texture(TEXTURE, UV).r);
	COLOR = fog;
	COLOR.a = 1.0 - tex.r;
	
}
