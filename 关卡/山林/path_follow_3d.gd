extends PathFollow3D


func _process(delta: float) -> void:
	var target_node: Node3D    = $"../../../VehicleBody3D"
	$Camera3D.look_at(target_node.position)
	if not target_node: 
		return
	
	# 1. 获取当前路径的 Curve3D 资源
	var curve = get_parent().curve
	if not curve: return
	
	# 2. 将目标的全局坐标转换为相对于 Path3D 的局部坐标
	var local_target_pos = get_parent().to_local(target_node.global_position)
	
	# 3. 使用 get_closest_offset 找到目标在曲线上最近的点对应的长度(米)
	var closest_offset = curve.get_closest_offset(local_target_pos)
	
	# 4. 更新 PathFollow3D 的 progress 属性使其靠近目标
	self.progress =  lerp(self.progress, closest_offset, 1 * delta)
