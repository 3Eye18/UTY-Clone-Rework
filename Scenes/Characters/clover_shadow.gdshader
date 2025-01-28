shader_type canvas_item;

// Adjust this value to control the darkness
// 0.5 for shadow
// 1 for normal
// 1.5 for light
uniform float darken_factor = 0.5;

void fragment() {
    // Get the original color of the sprite
    vec4 color = texture(TEXTURE, UV);

    // Darken the color by multiplying it by a factor (e.g., 0.5 for 50% darker)
    color.rgb *= darken_factor;

    // Output the modified color
    COLOR = color;
}