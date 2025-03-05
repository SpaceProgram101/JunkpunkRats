shader_type canvas_item;

uniform vec4 emission_color = vec4(1.0,1.0,0.0,1.0);

void fragment() {
  	vec4 texColor = texture(TEXTURE, FRAGCOORD.xy / SCREEN_PIXEL_SIZE);
	    
	// Apply the emission color only to the RGB channels based on alpha (preserve transparency)
	vec3 glow = emission_color.rgb * texColor.a;  // Only affect the color channels where alpha is non-zero

	// Combine the texture color with the glow effect (preserve the alpha)
	COLOR.rgb = texColor.rgb + glow;  // Add the glow to the texture's color channels
	COLOR.a = texColor.a;  // Preserve the alpha from the texture
}