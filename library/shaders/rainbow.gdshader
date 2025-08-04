shader_type canvas_item;

uniform float speed = -0.25;
uniform float warp = 8.0;

vec2 rotate(vec2 input, float a) {
	mat2 rotation = mat2(vec2(cos(a), -sin(a)), vec2(sin(a), cos(a)));
	return input * rotation;
}

void fragment() {
	vec2 distFromCenter = UV - vec2(0.5);
	vec2 uv = vec2(0.5) + rotate(distFromCenter, warp * length(distFromCenter));
	float t = mod(uv.x + uv.y + TIME * speed, 1.0) * 6.0;
	float r = clamp(2. - t, 0., 1.) + clamp(t - 4., 0., 1.);
	float g = min(1., 4. - t) - max(0., 1. - t);
	float b = min(1., 6. - t) - max(0, 3. - t);
	COLOR.rgb = vec3(r, g, b);
}
