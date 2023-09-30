shader_type canvas_item;

uniform float width = 10.0;
uniform vec4 color: source_color;
uniform float alpha_margin: hint_range(0.0, 1.0, 0.01) = 0.25;
uniform float uv_scale = 1.0;

const vec2[] Directions = {
	vec2(-0.1, 0.1), vec2(0.0, 0.1), vec2(0.1, 0.1), 
	vec2(-0.1, 0.0), vec2(0.1, 0.0), 
	vec2(-0.1, -0.1), vec2(0.0, -0.1), vec2(0.1, -0.1)
};


void fragment() {
	vec2 uv_scaled = vec2(0.5, 0.5) + uv_scale * (UV - vec2(0.5, 0.5));
	float w = width / float(textureSize(TEXTURE, 0).x);
	float[8] opacities;
	float totalOpacity = 0.0;
	for (int i = 0; i < 8; i++) {
		vec2 uv = uv_scaled + width * Directions[i];
		if (abs(0.5 - uv.x) > 0.5 || abs(0.5 - uv.y) > 0.5) {
			opacities[i] = 0.0;
			continue;
		}
		opacities[i] = texture(TEXTURE, uv).a;
		totalOpacity += opacities[i];
	}

	vec4 texColor = texture(TEXTURE, uv_scaled);
	bool isEdge = texColor.a < alpha_margin && 
		(opacities[3] != opacities[4] || opacities[1] != opacities[6]);
	
	if (isEdge) {
		COLOR = color;
		COLOR.a = step(0.2, smoothstep(0.0, 0.5, 0.125 * totalOpacity));
	} else {
		COLOR = texColor;
	}
	
}
