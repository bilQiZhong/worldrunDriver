shader_type canvas_item;
uniform sampler2D target_texture : source_color, filter_linear_mipmap_anisotropic; // 目标纹理
uniform float progress : hint_range(0.0, 1.0) = 0.0; // 过渡进度 (0~1)
void fragment() {
	
   COLOR  = mix( vec4(0,0,0,0),texture(target_texture,UV), progress) ;
	
}