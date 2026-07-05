extends Panel
var run=false
# 1. 声明一个类级别的 Tween 变量，用于追踪当前的过渡动画
var mat = material as ShaderMaterial
var glass
var o=0
var dud=true
func _ready() -> void:
	glass=$"../ColorRect".material as ShaderMaterial
func change()-> void:
	mat.set_shader_parameter("progress",0)
func _process(delta: float) -> void:
	if o>5 :
		visible=false
		if dud==0 :
			$"../../run".visible=true
			dud=1
		glass.set_shader_parameter("a",lerp(glass.get_shader_parameter("a"),0.00,5*delta))
	else:
		visible=true
	$".".size=DisplayServer.window_get_size()
	if mat.get_shader_parameter("progress")<0.99:
		mat.set_shader_parameter("progress", mat.get_shader_parameter("progress")+0.05)
	if not $"..".isrun:
		o=0
		glass.set_shader_parameter("a",3.00)
	elif $"..".isrun:
		if $"../../../level".get_texture().get_image().get_pixel(0,0).r>0.8 and o<6:
			o+=1
			
