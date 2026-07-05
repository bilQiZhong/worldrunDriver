extends PathFollow3D
var target_node: Node3D
var speed = 8.0 # 全局速度设置
var _smooth_basis: Basis = Basis.IDENTITY

func _ready() -> void:
	if $"../../../".get_child_count()>1:
		target_node = $"../../../".get_child(1)
	$"../../AudioStreamPlayer".playing=true
	_smooth_basis = global_transform.basis
func _process(delta: float) -> void:
	if target_node==null and $"../../../".get_child_count()>1:
		target_node = $"../../../".get_child(1)
	smooth_camera_to_3d($"../Camera3D",position+Vector3(10,20,0))
	look_at_dis($"../Camera3D",position)
	if not target_node: 
		return
	# 1. 获取当前路径的 Curve3D 资源
	var curve = get_parent().curve
	if not curve: return
	
	# 2. 将目标的全局坐标转换为相对于 Path3D 的局部坐标
	var local_target_pos = get_parent().to_local(target_node.global_position)
	
	# 3. 使用 get_closest_offset 找到目标在曲线上最近的点对应的长度(米)
	var closest_offset = curve.get_closest_offset(local_target_pos)
	self.progress =  lerp(self.progress, closest_offset, 10 * delta)
#	$"../../AudioStreamPlayer".seek(lerp($"../../AudioStreamPlayer".get_playback_position(),(progress_ratio-($"../../AudioStreamPlayer".get_playback_position()/$"../../AudioStreamPlayer".stream.get_length()))*$"../../AudioStreamPlayer".stream.get_length(),5*delta))
#	print((progress_ratio-($"../../AudioStreamPlayer".get_playback_position()/$"../../AudioStreamPlayer".stream.get_length()))*$"../../AudioStreamPlayer".stream.get_length())
	#seek_audio_to_progress_by_speed(progress_ratio,1.2,0.8)
# 专为 Camera3D 设计的平滑移动函数
# 调用示例：smooth_camera_to_3d($Camera3D, player.global_position, 0.35, 10.0)
# 专为 Camera3D 设计的平滑移动函数
# 调用示例：smooth_camera_to_3d($Camera3D, player.global_position, 0.35, 10.0)
# 专为 Camera3D 设计的平滑移动函数（Godot 4.x 版）
# 调用示例：smooth_camera_to_3d(self, player.global_position, 5.0, 15.0)
func smooth_camera_to_3d(
	camera: Camera3D,
	target_global_pos: Vector3,
	smooth_speed: float = 1.0,  # 平滑速度（值越大响应越快，推荐 3.0~8.0）
	max_speed: float = 15.0     # 最大移动速度（单位：米/秒，防剧烈抖动）
) -> void:
	# 1. 获取相机当前全局位置
	if target_node!=null:
		var current_pos = camera.global_position
		camera.look_at(target_node.position)
		# 2. 计算方向与距离（提前判断避免无效计算）
		var direction = target_global_pos - current_pos
		var distance = direction.length()
		if distance <= 0.01:
			return  # 已接近目标，无需计算
		
		# 3. 限制单帧最大移动距离（防止目标突变时相机失控）
		var delta = get_process_delta_time()
		var step = min(distance, max_speed * delta)
		# 4. 使用 lerp 结合 delta 实现动态阻尼平滑
		# smooth_speed 控制插值权重，乘以 delta 保证帧率无关
		var weight = clamp(smooth_speed * delta, 0.0, 1.0)
		var smooth_target = current_pos.lerp(target_global_pos, weight)
		
		# 5. 应用平滑后的位置
		camera.global_position = smooth_target



var bus


# 音频节点引用
func seek_audio_to_progress_by_speed(progress_ratio: float, max_speed: float = 2.0, min_speed: float = 0.3, tolerance: float = 0.1):
	"""
	通过调节音频播放速度平滑跳转到目标进度
	
	参数:
		progress_ratio: 目标进度比例 (0.0 - 1.0)
		max_speed: 最大加速倍数（默认 2.0 倍速）
		min_speed: 最小减速倍数（默认 0.3 倍速）
		tolerance: 容忍误差（秒），小于该值时恢复正常速度
	
	返回:
		bool: 成功返回 true，失败返回 false
	"""
	
	# 🔍 获取音频节点
	var audio =  $"../../AudioStreamPlayer"
	if not audio or not audio.stream:
		print("错误：AudioStreamPlayer 节点不存在或未加载音频！")
		return false
	
	# 📏 限制进度范围
	progress_ratio = clamp(progress_ratio, 0.0, 1.0)
	
	# 📊 计算目标位置和当前位置
	var total_length = audio.stream.get_length()
	var target_position = progress_ratio * total_length
	var current_position = audio.get_playback_position()
	
	# ✅ 如果已经在目标位置附近，恢复正常速度并返回
	if abs(current_position - target_position) <= tolerance:
		if audio.pitch_scale != 1.0:
			audio.pitch_scale = 1.0
		return true
	
	# 🎬 计算速度调节
	var speed_factor = 1.0
	
	if target_position > current_position:
		# 目标在后面，需要加速播放（快进）
		# 计算距离，距离越远加速越快
		var distance = target_position - current_position
		var max_distance = total_length * 0.5  # 最大调节距离为总长度的一半
		var ratio = clamp(distance / max_distance, 0.0, 1.0)
		speed_factor = lerp(1.0, max_speed, ratio)
		
		
	else:
		# 目标在前面，需要减速播放（慢放）
		# 计算距离，距离越远减速越慢
		var distance = current_position - target_position
		var max_distance = total_length * 0.5
		var ratio = clamp(distance / max_distance, 0.0, 1.0)
		speed_factor = lerp(1.0, min_speed, ratio)
		
	
	# 🎯 应用速度调节
	audio.pitch_scale = speed_factor
	bus=AudioServer.get_bus_effect(AudioServer.get_bus_index("BGM"),0 )
	bus.pitch_scale=1/speed_factor
	# 🔄 确保音频在播放
	
	return true

# 内部变量，用于记录平滑后的当前朝向


func look_at_dis(camera: Camera3D, target_global_pos: Vector3, dis: float = 1.0) -> void:
	# 1. 边界检查：防抖系数不能为0，否则会导致除零错误
	if dis <= 0.0:
		dis = 0.001
		
	# 2. 计算看向目标的理想基础朝向
	var direction: Vector3 = target_global_pos - camera.global_position
	if direction.length_squared() > 0.001: # 防止目标与相机重合导致万向节死锁
		var target_basis: Basis = Basis.looking_at(direction, Vector3.UP)
		
		# 3. 核心防抖逻辑：使用 slerp 对 Basis 进行球面线性插值
		# dis 越大，插值权重越小，相机转动越慢、越平滑（防抖效果越强）
		var weight: float = clamp((1.0 / dis) * get_process_delta_time() * 60.0, 0.01, 1.0)
#00
		var current_quat = _smooth_basis.get_rotation_quaternion()

		var target_quat = target_basis.get_rotation_quaternion()

		var interpolated_quat = current_quat.slerp(target_quat, weight)

		_smooth_basis = Basis(interpolated_quat)
		
		# 4. 将平滑后的朝向直接应用到相机的 Transform 上
		# 保持相机原有的位置不变，只更新旋转
		var current_transform: Transform3D = camera.global_transform
		current_transform.basis = _smooth_basis
		camera.global_transform = current_transform
