shader_type canvas_item;

uniform vec2 dir = vec2(1.0, 1.0);
uniform sampler2D overlay;
uniform vec2 scale = vec2(1.0, 1.0);
uniform vec4 modulate: source_color;


void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 overlayTex = modulate * texture(overlay, fract(UV * scale + dir * TIME));
	float opacity = modulate.a * tex.a;
	COLOR = opacity * overlayTex + (1.0 - opacity) * tex;
}
