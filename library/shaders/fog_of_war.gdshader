shader_type canvas_item;

uniform float timeScale = 1.0;
uniform sampler2D fogTexture;
uniform float fogScale = 1.0;
uniform float fog_wave = 1.0;

void fragment() {
	// moving noisevec3
	vec4 tex1 = texture(fogTexture, fract(fogScale * UV + timeScale * TIME * vec2(-0.083, 0.17)));
	vec4 tex2 = texture(fogTexture, fract(fogScale * UV + timeScale * TIME * vec2(0.12, -0.07)));
	vec4 noise_moving = tex1 * tex2;
	
	// opacity from red channel
	vec4 tex = texture(TEXTURE, UV);
	tex.a = 1.0 - tex.r;
	
	COLOR.rgb = vec3(0.0, 0.0, 0.0);
	COLOR.a = tex.a + tex.a * fog_wave * noise_moving.r;
}
