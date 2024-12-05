shader_type canvas_item;

uniform sampler2D background;
uniform float speed: hint_range(0.0, 10.0, 0.1);
uniform float shadowAmount: hint_range(-1.0, 1.0, 0.1);

void vertex() {
	float c = cos(TIME * speed);
	VERTEX.x = (0.5 - VERTEX.x) * sign(c) * sqrt(abs(c));
}

void fragment() {
	if (cos(TIME * speed) > 0.0) {
		COLOR = texture(TEXTURE, UV);
		COLOR.rgb += shadowAmount * sin(TIME * speed);
	} else {
		COLOR = texture(background, UV);
		COLOR.rgb -= shadowAmount * sin(TIME * speed);
	}
}