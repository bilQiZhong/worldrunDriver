extends Control
var isrun=false
var level=0
var del=false
signal bottom_down 
signal load_over(objects)
var load_finish=false
func clear_all_children():
	# 获取当前节点的所有子节点并遍历
	for child in $"../../level".get_children():
		child.queue_free() # 将每个子节点加入释放队列
func in_world(objects):
	$"../../level".add_child(objects)
	load_finish=true
func _ready():
	
	get_window().connect("size_changed", Callable(self, "_on_window_size_changed"))
	bottom_down.connect(Callable($"../pause/dead" , "_on_exit_button_down"))
	load_over.connect(self.in_world) 
func _on_window_size_changed():
	$setcar.size=Vector2(DisplayServer.window_get_size().x/2,DisplayServer.window_get_size().y/2)
	$setcar.position.y=DisplayServer.window_get_size().y/2
	$setlevel.size=Vector2(DisplayServer.window_get_size().x/2,DisplayServer.window_get_size().y)
	$setlevel.position=Vector2(DisplayServer.window_get_size().x/2,0)
	$view.size=(Vector2(DisplayServer.window_get_size().x/2,DisplayServer.window_get_size().y/2))
	$ColorRect.size=DisplayServer.window_get_size()
	$"../../SubViewport2".size=DisplayServer.window_get_size()
	$"../../level".size==DisplayServer.window_get_size()
	$"../running/SubViewportContainer/SubViewport".size=$"../running/SubViewportContainer/SubViewport".size*1.5
	$"../running/SubViewportContainer".size=DisplayServer.window_get_size()
	$"../running/Control".position=Vector2(DisplayServer.window_get_size())/Vector2(2,1.25)
	$"../../SubViewport2/TextureRect".size=DisplayServer.window_get_size()
	$"../running/SubViewportContainer/SubViewport/TextureRect".size=DisplayServer.window_get_size()
	$"../run/Button".size=DisplayServer.window_get_size()
	$"../pause/dead".position=Vector2(DisplayServer.window_get_size())/Vector2(2,1.25)-Vector2(102,68)
	
func loadcar()->void:
		if $"../..".carindex==0:
			var sk=load("res://车/小车/car.tscn").instantiate()
			$"../../level".call_deferred("add_child", sk)
		elif $"../..".carindex==1:
			var sk=load("res://车/大车/car.tscn").instantiate()
			$"../../level".call_deferred("add_child", sk)
func _on_setlevel_item_activated(index: int) -> void:
	$"setlevel/光/Node3D".visible=false
	isrun=true
	$Button.visible=false
	$"../../SubViewport/Node3D/StaticBody3D/CollisionShape3D".disabled=true
	$"../../SubViewport/Node3D/StaticBody3D/CollisionShape3D2".disabled=true
	level=index
	if level==0:
		Thread.new().start(loadone.bind("res://关卡/山林/山林.tscn"))
		#$"../../SubViewport2/TextureRect".texture=preload()
		$"../../SubViewport/Node3D/bin".free()
	elif level==1:
		Thread.new().start(loadone.bind("res://关卡/星空/星空.tscn"))
		$"../../SubViewport/Node3D/bin".free()
	elif level==2:
		Thread.new().start(loadone.bind("res://关卡/时光之心/光.tscn"))
		$"../../SubViewport/Node3D/bin".free()
func _on_exit_button_down() -> void:
	$Button.visible=true
	$"setlevel/光/Node3D".visible=true
	$background.visible=true
	load_finish=false
	isrun=false
	$".".visible=true
	$"../pause".visible=false
	$"../../SubViewport/Node3D/StaticBody3D/CollisionShape3D".disabled=false
	$"../../SubViewport/Node3D/StaticBody3D/CollisionShape3D2".disabled=false
	clear_all_children()
	if $"../..".carindex==0:
		$"../../SubViewport/Node3D/bin".add_child(load("res://车/小车/car.tscn").instantiate())
	elif $"../..".carindex==1:
		$"../../SubViewport/Node3D/bin".add_child(load("res://车/大车/car.tscn").instantiate())
func _process(delta: float) -> void:
	if del:
		$Button.scale=lerp($Button.scale,Vector2(0.8,0.8),3*delta)
	else:
		$Button.scale=lerp($Button.scale,Vector2(1,1),3*delta)
	if isrun:
		$setcar.position=lerp($setcar.position,Vector2(DisplayServer.window_get_size().x,DisplayServer.window_get_size().y/2),4*delta)
		$view.position=lerp($view.position,Vector2( 0-DisplayServer.window_get_size().x,0),delta*1)
		$setlevel.position=lerp($setlevel.position,Vector2(DisplayServer.window_get_size().x,0),4*delta)
		if $setlevel.position.x>DisplayServer.window_get_size().x-2:
			$"../running".visible=true
			$"../../SubViewport/Node3D".visible=false
			$"../../SubViewport/Node3D".visible=true
		if get_node_or_null("../../level/VehicleBody3D") !=null:
			if$"../../level/VehicleBody3D".steering==0:
				$"../running/Control".rotation=lerp($"../running/Control".rotation,0.00,delta*5)
			else:
				$"../running/Control".rotation=$"../../level/VehicleBody3D".steering/-2

	else:
		$view.position=lerp($view.position,Vector2(0,0),delta*1)
		$setcar.position=lerp($setcar.position,Vector2(0,DisplayServer.window_get_size().y/2),4*delta)
		$setlevel.position=lerp($setlevel.position,Vector2(DisplayServer.window_get_size().x/2,0),4*delta)
		$"../running".visible=false
		$"../running".visible=false
		$"../../SubViewport/Node3D".visible=true
func _on_setlevel_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index==0 and level !=index:
		var scene=load("res://fade.tscn").instantiate()
		scene.mat.set_shader_parameter("target_texture",$background.mat.get_shader_parameter("target_texture"))
		$background.add_child(scene)
		$background.mat.set_shader_parameter("target_texture",load("res://关卡/山林/icon.svg"))
		$background.change()
	elif index==1 and level !=index:
		var scene=preload("res://fade.tscn").instantiate()
		scene.mat.set_shader_parameter("target_texture",$background.mat.get_shader_parameter("target_texture"))
		$background.add_child(scene)
		$background.mat.set_shader_parameter("target_texture",load("res://关卡/星空/屏幕截图 2026-05-11 130753.png"))
		$background.change()
	elif index==2 and index!=level:
		var scene=preload("res://fade.tscn").instantiate()
		scene.mat.set_shader_parameter("target_texture",$background.mat.get_shader_parameter("target_texture"))
		$background.add_child(scene)
		$background.mat.set_shader_parameter("target_texture",load("res://关卡/时光之心/外部文件/0215.png"))
		$background.change()
	level=index
func loadone(path:  String):
	call_deferred("emit_signal", "load_over",  load(path).instantiate()) 
	loadcar()
func _on_dead_button_down() -> void:
	load_finish=false
	$"../pause".visible=false
	clear_all_children()
	if level==0:
		Thread.new().start(loadone.bind("res://关卡/山林/山林.tscn"))
		
	elif level==1:
		Thread.new().start(loadone.bind("res://关卡/星空/星空.tscn"))

	elif level==2:
		Thread.new().start(loadone.bind("res://关卡/时光之心/光.tscn"))


func _on_button_mouse_entered() -> void:
	del=true


func _on_button_mouse_exited() -> void:
	del=false
