shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.25;
uniform float offset: hint_range(0.0, 1.0, 0.125) = 0.5;
uniform float trail: hint_range(0.0, 0.3, 0.01) = 0.1;
uniform float trail_smoothing: hint_range(0.0, 0.3, 0.01) = 0.1;


void fragment() {
	if (progress != 1.0) {
	    vec4 tex_color = texture(TEXTURE, UV);
	    
	    vec2 rel_pos = UV - vec2(0.5);
	    
	    float angle = atan(rel_pos.x, -rel_pos.y); 
	    
	    float angle_0_to_1 = (angle + PI) / TAU;
		angle_0_to_1 = mod((angle_0_to_1 + offset), 1.0);
	    
	    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
	    vec3 grayscale_color = vec3(gray);
	    
	    if (angle_0_to_1 > progress) {
	        COLOR = vec4(grayscale_color, tex_color.a);
	    } else {
	        COLOR = tex_color;
			float offset_diff = progress - angle_0_to_1;
			vec3 highlight = vec3(2.0) * max(0.0, trail - offset_diff);
			COLOR.rgb += smoothstep(highlight, vec3(0.0), vec3(trail_smoothing));
	    }
	}
}
