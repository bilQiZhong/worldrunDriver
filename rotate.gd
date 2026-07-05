extends Marker3D
var isin=false
var xl
func _on_view_mouse_entered() -> void:
	isin=true


func _on_view_mouse_exited() -> void:
	isin=false
func _process(delta: float) -> void:
	if isin and Input.is_action_pressed("click"):
		pass

func _input(event: InputEvent) -> void:
	# 检查当前输入事件是否为鼠标移动
	if event is InputEventMouseMotion:
		# 获取鼠标移动的相对增量
		var relative_motion = event.relative 
		# 示例：根据鼠标水平移动增量来左右旋转当前节点
		rotation+=-relative_motion.x * 10
