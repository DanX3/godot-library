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

vec2 distort(sampler2D noise, vec2 uv, float time) {
	vec2 uv1 = uv + time * vec2(0.2, 0.1);
	vec2 uv2 = fract(uv + time * vec2(0.25, 0.4));
	vec4 noise1 = texture(noise, uv1);
	vec4 noise2 = texture(noise, uv2);
	vec4 offset = noise1 + noise2 - vec4(1.0);
	return offset.rg;
}