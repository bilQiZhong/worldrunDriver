extends Panel
var run=true
# 1. 声明一个类级别的 Tween 变量，用于追踪当前的过渡动画
var mat = material as ShaderMaterial
func _ready() -> void:
	mat.set_shader_parameter("progress",$"../".mat.get_shader_parameter("progress"))
	
func _process(delta: float) -> void:
	$".".size=DisplayServer.window_get_size()
	mat.set_shader_parameter("progress",mat.get_shader_parameter("progress")-0.05)
	if mat.get_shader_parameter("progress")<0.02:
		free()
	
		
