shader_type canvas_item;

uniform sampler2D texture;  // The texture to tile
uniform vec2 tile_size = vec2(32.0, 32.0); // Default tile size (adjust as needed)

void fragment() {
    // Get the UV coordinates of the fragment relative to the Sprite2D's size
    vec2 uv = FRAGCOORD.xy / tile_size;
    
    // Sample the texture at the tiled UV position
    vec4 texColor = texture(texture, uv);
    
    // Set the final color
    COLOR = texColor;
}