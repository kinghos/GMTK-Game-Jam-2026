shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float radius : hint_range(0.0, 5.0) = 3.0;
uniform vec2 center = vec2(0.5, 0.5);

uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;
uniform float darken_amount : hint_range(0.0, 1.0) = 0.75;

void fragment() {
    // 1. Calculate aspect ratio using built-in screen pixel size
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    
    // 2. Adjust UV and Center for perfect circles
    vec2 adjusted_uv = UV;
    adjusted_uv.x *= aspect_ratio;
    
    vec2 adjusted_center = center;
    adjusted_center.x *= aspect_ratio;

    // 3. Calculate mask using the adjusted coordinates
    float dist = distance(adjusted_uv, adjusted_center);
    float mask = smoothstep(radius, radius - 0.1, dist);

    // 4. Background blur and darkening
    vec4 blurred_screen = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);
    vec4 darkened_bg = blurred_screen * (1.0 - darken_amount);
    darkened_bg.a = 1.0;

    // 5. Final mix
    COLOR = mix(darkened_bg, vec4(0.0, 0.0, 0.0, 0.0), mask);
}