shader_type canvas_item;

uniform float width = 0.1;
uniform vec3 color: source_color = vec3(1.0, 1.0, 0.5);
uniform float smoothWidth = 0.4;
uniform float speed = 1;
uniform float period : hint_range(1, 10) = 2.0;

void fragment() {
	// weight sampling between distances; used to manage the speed and period
	float t = min(1.0, period * fract(TIME * speed / period));
	// shine diagonal; compensate for width and smoothWidth
	float dist = mix(-width - smoothWidth, 1.0 + width + smoothWidth, t);
	// if the current UV point has a distance less than Width from the shine diagonal, it's shining
	float diff = abs(0.5 * (UV.x + UV.y) - dist);
	float edge0 = diff - 0.5 * smoothWidth;
	float edge1 = diff + 0.5 * smoothWidth;
	float isWhite = smoothstep(edge0, edge1, width);
	// sample texture and set COLOR based on shine
	vec4 tex = texture(TEXTURE, UV);
	COLOR = tex + isWhite * vec4(color, tex.a);
}