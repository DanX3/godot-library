shader_type canvas_item;

// Uniforms allow you to pass data from your script to the shader.

// The screen texture contains the rendered image behind the node this shader is applied to.
uniform sampler2D screen_texture : hint_screen_texture;

// The mask texture defines the shape and falloff of the impact.
// White areas will be warped most, black areas not at all.
uniform sampler2D mask_texture;

// The center position of the impact in UV coordinates (0.0 to 1.0).
// You'll likely pass the impact point from a script.
uniform vec2 impact_position = vec2(0.5, 0.5);

// The radius of the impact effect.
uniform float impact_radius = 0.3;

// The strength of the warp effect. Higher values mean more distortion.
uniform float warp_strength = 0.05;

uniform float opacity : hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
    // Get the current UV coordinates for the fragment.
    vec2 current_uv = SCREEN_UV;

    // Calculate the distance from the current fragment to the impact position.
    float dist = distance(current_uv, impact_position);

    // Sample the mask texture at the current UV.
    // We'll use the red channel (or any single channel) of the mask.
    float mask_value = max(0, opacity) * texture(mask_texture, (current_uv - impact_position) / impact_radius + 0.5).r;

    // Adjust the mask value based on distance to create a falloff from the center,
    // and also respect the impact_radius.
    // The clamp ensures the value stays between 0 and 1.
    // We only want to apply the warp within the defined impact_radius.
    float effective_mask = mask_value * (1.0 - smoothstep(impact_radius * 0.8, impact_radius, dist));
    effective_mask = clamp(effective_mask, 0.0, 1.0);

    // Calculate the direction vector from the impact center to the current fragment.
    vec2 dir = normalize(current_uv - impact_position);

    // Apply the warp. The warp amount is stronger closer to the center of the impact
    // and scaled by the warp_strength and the effective_mask.
    vec2 warped_uv = current_uv + dir * effective_mask * warp_strength;

    // Sample the screen texture with the warped UV coordinates.
    vec4 color = texture(screen_texture, warped_uv);

    // Output the final color.
    COLOR = color;
}