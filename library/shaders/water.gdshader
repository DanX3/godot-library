shader_type canvas_item;

uniform sampler2D noiseTex;
uniform sampler2D waterNoise;
uniform sampler2D foamNoise;
uniform vec4 baseColor1: source_color;
uniform vec4 baseColor2: source_color;
uniform vec2 speed = vec2(1.0, 1.0);
uniform vec2 scale = vec2(1.0, 1.0);
uniform float reflectionsAmount: hint_range(0.0, 1.0) = 0.5;
uniform vec2 reflectionsSpeed = vec2(1.0, 1.0);
uniform vec2 reflectionScale = vec2(1.0, 1.0);
uniform float foamAmount: hint_range(0.0, 1.0) = 0.5;
uniform vec2 foamScale = vec2(1.0, 1.0);
uniform vec2 foamSpeed = vec2(1.0, 1.0);
uniform vec3 foamColor: source_color;

void fragment() {
	vec2 uv1 = fract(scale * UV + TIME * speed);
	vec2 uv2 = fract(vec2(0.8, 1.5) * scale * UV + TIME * speed * vec2(0.7, -0.4));

	// base color
	vec4 noise1 = texture(noiseTex, uv1);
	vec4 noise2 = texture(noiseTex, uv2);
	vec4 noise = noise1 * noise2;
	vec4 c = (1.0 - noise.r * 0.5) * baseColor1 + 0.5 * noise.r * baseColor2;
	COLOR = mix(baseColor1, baseColor2, noise.r + noise.g + noise.b);

	// foam
	vec4 foam = texture(foamNoise, fract(foamScale * UV + TIME * foamSpeed));
	vec4 noise3 = texture(noiseTex, fract(0.2 * scale * UV + TIME * speed * vec2(-0.3, 0.5)));
	vec3 foamMask = step(1.0 - foamAmount, 0.5 * (foam +  noise2 * noise2)).rgb;
	COLOR.rgb *= vec3(1.0) - foamMask;
	COLOR.rgb += foamColor * foamMask;

	// reflections
	vec3 water1 = texture(waterNoise, fract(vec2(1.2, 1.6) * reflectionScale * UV + TIME * reflectionsSpeed)).rgb;
	vec3 water2 = texture(waterNoise, fract(vec2(1.8, 2.5) * reflectionScale * UV + TIME * reflectionsSpeed)).rgb;
	COLOR.rgb += vec3(1.0) - step(reflectionsAmount, water1 * water2);
}
