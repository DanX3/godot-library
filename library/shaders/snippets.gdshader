shader_type spatial;

float isOutline(sampler2D tex, vec2 uv, float dist) {
	dist /= float(textureSize(tex, 0).x);
	vec4 tex0 = texture(tex, uv);
	vec4 tex1 = texture(tex, uv + vec2(-dist, -dist));
	vec4 tex4 = texture(tex, uv + vec2(dist, -dist));
	vec4 tex2 = texture(tex, uv + vec2(-dist, dist));
	vec4 tex3 = texture(tex, uv + vec2(dist, dist));
	return step(0.5, tex1.a + tex2.a + tex3.a + tex4.a) - step(0.1, tex0.a);
}