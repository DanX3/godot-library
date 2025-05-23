shader_type canvas_item;

uniform sampler2D noise_tex;
uniform float progress: hint_range(0.0, 1.0) = 0.0;
uniform vec4 color: source_color;
uniform float thickness: hint_range(0.0, 0.5);
uniform vec2 scale = vec2(1.0, 1.0);

/// reduces the gap around progress where nothing would happen because of texture values
uniform float zoom: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	float noise = texture(noise_tex, fract(scale * UV)).r;
	float progress_zoomed =  0.5 * zoom // starting point
		// slowed down progress rate
		+ ((1.0 - zoom) / 1.0) * (1.0 - progress);

	float progress_noised = progress_zoomed + noise;
	vec4 tex = texture(TEXTURE, UV);
	float noise_alpha = tex.a * step(1.0, progress_noised);
	COLOR = tex;
	// is outline
	if (abs(1.0 - (progress_noised)) < thickness)
		COLOR = color;
	COLOR.a = noise_alpha;
}
