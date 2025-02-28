shader_type canvas_item;

uniform float transition_time : hint_range(0.0, 5.0) = 2.0; // Time for the transition to take place
uniform float progress : hint_range(0.0, 1.0) = 0.0; // The progress of the transition, from 0 to 1

void fragment() {
    vec4 texColor = texture(TEXTURE, FRAGCOORD.xy / TEXTURE_PIXEL_SIZE);
    vec4 finalColor = mix(texColor, vec4(1.0, 1.0, 1.0, 1.0), progress);
    COLOR = finalColor;
}