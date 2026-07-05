shader_type canvas_item;

// 拖影强度 (0.0 = 清晰, 0.9 = 强拖影)
uniform float blend_factor : hint_range(0.0, 0.95) = 0.9;

// 当前这一帧 SubViewport_A 渲染出来的画面
uniform sampler2D current_frame; 

// 上一帧处理完的画面 (由 GDScript 传入)
uniform sampler2D previous_frame; 

void fragment() {
    vec4 cur_col = texture(current_frame, UV);
    vec4 prev_col = texture(previous_frame, UV);
    vec4 final_color = mix(cur_col, prev_col, blend_factor);
    
    COLOR = final_color;
}