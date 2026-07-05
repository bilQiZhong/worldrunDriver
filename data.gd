extends Node
var carindex
var config
var mass
func _ready() -> void:
	config = ConfigFile.new()
	config.load("res://savegame.cfg")
	if config.get_value("Player","car")==null:
		config.set_value("Player", "car", 0)
		config.set_value("Player", "mass",0)
		config.set_value("Player", "window", 0)
		config.set_value("Player", "speed", 100)
		config.set_value("Player", "level", 0)
		config.save("res://savegame.cfg")
	carindex=config.get_value("Player","car")
	mass=config.get_value("Player","mass")
	$Control/start.level=config.get_value("Player","level")
	$Control/start/setting.mass=mass
	$Control/start/setting.windows=config.get_value("Player","window")
	$"../".content_scale_size=DisplayServer.screen_get_size()
	DisplayServer.window_set_size(Vector2(  DisplayServer.screen_get_size().x/1.5, DisplayServer.screen_get_size().y/1.5 ))
	DisplayServer.window_set_position(Vector2( DisplayServer.screen_get_size().x/4, DisplayServer.screen_get_size().y/4))
	if carindex==0:
		$SubViewport/Node3D/bin.add_child(preload("res://车/小车/car.tscn").instantiate())
	elif carindex==1:
		$SubViewport/Node3D/bin.add_child(preload("res://车/大车/car.tscn").instantiate())
	if mass==0:
		$SubViewport.msaa_2d=Viewport.MSAA_DISABLED
		$SubViewport.msaa_3d=Viewport.MSAA_DISABLED
		$level.msaa_2d=Viewport.MSAA_DISABLED
		$level.msaa_3d=Viewport.MSAA_DISABLED
		$Control/start/setting/ColorRect/Label2/MenuButton.text="无"
		$"..".msaa_2d=Viewport.MSAA_DISABLED
	elif mass==1:
		$SubViewport.msaa_2d=Viewport.MSAA_2X
		$SubViewport.msaa_3d=Viewport.MSAA_2X
		$level.msaa_2d=Viewport.MSAA_2X
		$level.msaa_3d=Viewport.MSAA_2X
		$Control/start/setting/ColorRect/Label2/MenuButton.text="X2"
		$"..".msaa_2d=Viewport.MSAA_2X
	elif mass==2:
		$SubViewport.msaa_2d=Viewport.MSAA_4X
		$SubViewport.msaa_3d=Viewport.MSAA_4X
		$level.msaa_2d=Viewport.MSAA_4X
		$level.msaa_3d=Viewport.MSAA_4X
		$Control/start/setting/ColorRect/Label2/MenuButton.text="X4"
		$"..".msaa_2d=Viewport.MSAA_4X
	elif mass==3:
		$SubViewport.msaa_2d=Viewport.MSAA_8X
		$SubViewport.msaa_3d=Viewport.MSAA_8X
		$level.msaa_2d=Viewport.MSAA_8X
		$level.msaa_3d=Viewport.MSAA_8X
		$Control/start/setting/ColorRect/Label2/MenuButton.text="X8"
		$"..".msaa_2d=Viewport.MSAA_8X
	if config.get_value("Player","window")==0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif config.get_value("Player","window")==1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	$Control/start/setting/ColorRect/Label3/HSlider.value=config.get_value("Player","speed")
	if config.get_value("Player","level")==0:
		var scene=preload("res://fade.tscn").instantiate()
		scene.mat.set_shader_parameter("target_texture",$Control/start/background.mat.get_shader_parameter("target_texture"))
		$Control/start/background.add_child(scene)
		$Control/start/background.mat.set_shader_parameter("target_texture",preload("res://关卡/山林/icon.svg"))
		$Control/start/background.change()
	elif config.get_value("Player","level")==1 :
		var scene=preload("res://fade.tscn").instantiate()
		scene.mat.set_shader_parameter("target_texture",$Control/start/background.mat.get_shader_parameter("target_texture"))
		$Control/start/background.add_child(scene)
		$Control/start/background.mat.set_shader_parameter("target_texture",preload("res://关卡/星空/屏幕截图 2026-05-11 130753.png"))
		$Control/start/background.change()
func _on_setcar_item_activated(index: int) -> void:
	carindex=index

func _exit_tree() -> void:
	config = ConfigFile.new()
	
	# 存储一些值。
	config.set_value("Player", "car", carindex)
	config.set_value("Player", "mass", $Control/start/setting.mass)
	config.set_value("Player", "window", $Control/start/setting.windows)
	config.set_value("Player", "speed", $Control/start/setting/ColorRect/Label3/HSlider.value)
	config.set_value("Player", "level", $Control/start.level)
	# 将其保存到文件中（如果已存在则覆盖）。
	config.save("res://savegame.cfg")
	
