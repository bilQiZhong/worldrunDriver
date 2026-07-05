extends Control
var is_down=false
var windows=0
var mass=0
func _ready():
	mass=$"../../..".mass
	var popup = $ColorRect/Label/MenuButton.get_popup()
	# 连接 id_pressed 信号
	popup.id_pressed.connect(_on_menu_item_pressed)
	var popupc = $ColorRect/Label2/MenuButton.get_popup()
	# 连接 id_pressed 信号
	popupc.id_pressed.connect(_on_menu_item_pressedc)
	
func _on_menu_item_pressed(id: int):
	windows=id
	if windows==0:
		$ColorRect/Label/MenuButton.text="窗口"
		DisplayServer.window_set_size(Vector2(  DisplayServer.screen_get_size().x/1.5, DisplayServer.screen_get_size().y/1.5 ))
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		$"../../../..".content_scale_size=DisplayServer.screen_get_size()
	elif windows==1:
		
		$ColorRect/Label/MenuButton.text="全屏"
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
		$"../../../..".content_scale_size=DisplayServer.screen_get_size()
func _on_menu_item_pressedc(id:int):
	mass=id
	if id==0:
		$"../../../SubViewport".msaa_2d=Viewport.MSAA_DISABLED
		$"../../../SubViewport".msaa_3d=Viewport.MSAA_DISABLED
		$"../../../level".msaa_2d=Viewport.MSAA_DISABLED
		$"../../../level".msaa_3d=Viewport.MSAA_DISABLED
		$ColorRect/Label2/MenuButton.text="无"
		$"../../../..".msaa_2d=Viewport.MSAA_DISABLED
	elif id==1:
		$"../../../SubViewport".msaa_2d=Viewport.MSAA_2X
		$"../../../SubViewport".msaa_3d=Viewport.MSAA_2X
		$"../../../level".msaa_2d=Viewport.MSAA_2X
		$"../../../level".msaa_3d=Viewport.MSAA_2X
		$ColorRect/Label2/MenuButton.text="X2"
		$"../../../..".msaa_2d=Viewport.MSAA_2X
	elif id==2:
		$"../../../SubViewport".msaa_2d=Viewport.MSAA_4X
		$"../../../SubViewport".msaa_3d=Viewport.MSAA_4X
		$"../../../level".msaa_2d=Viewport.MSAA_4X
		$"../../../level".msaa_3d=Viewport.MSAA_4X
		$ColorRect/Label2/MenuButton.text="X4"
		$"../../../..".msaa_2d=Viewport.MSAA_4X
	elif id==3:
		$"../../../SubViewport".msaa_2d=Viewport.MSAA_8X
		$"../../../SubViewport".msaa_3d=Viewport.MSAA_8X
		$"../../../level".msaa_2d=Viewport.MSAA_8X
		$"../../../level".msaa_3d=Viewport.MSAA_8X
		$ColorRect/Label2/MenuButton.text="X8"
		$"../../../..".msaa_2d=Viewport.MSAA_8X
func _on_button_pressed() -> void:
	is_down=not is_down
func _process(delta: float) -> void:
	$"../../running/SubViewportContainer/SubViewport/TextureRect".size=DisplayServer.window_get_size()
	$"../../../level".size=DisplayServer.window_get_size()
	$"../setlevel".icon_scale=DisplayServer.window_get_size().x/500
	$"../setcar".icon_scale=DisplayServer.window_get_size().x/500
	if is_down:
		position =position.lerp(Vector2(0,300),10*delta)
	else :
		position =position.lerp(Vector2(0,0),10*delta)


func _on_button_presseds() -> void:
	get_tree().quit()
