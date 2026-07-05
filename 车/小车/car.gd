extends VehicleBody3D
var mous=0
var fx =preload("res://车/小车/cartest(破碎).tscn")
var gamerun=false
func  _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		mous=DisplayServer.mouse_get_position().x
	if Input.is_action_pressed("click") and get_node_or_null("../../Control/start/setting/ColorRect/Label3/HSlider")  != null:
		steering=(mous-DisplayServer.mouse_get_position().x) /(1000-($"../../Control/start/setting/ColorRect/Label3/HSlider".value as float))   #Input.get_axis("left","right")*-0.4
	else:
		steering=0
		brake=0
	if gamerun:
		brake=0
		engine_force=(100-linear_velocity.length())
	else:
		engine_force=0
		brake=100
func _ready() -> void:
	gamerun=false
func _process(delta: float) -> void:
	if get_node_or_null("../../Control/pause")!=null:
		if $"../../Control/pause" !=null:
			if $"../../Control/pause".visible:
				$"../../Control/pause".position=lerp($"../../Control/pause".position,Vector2(0,0),delta*5)
			elif not $"../../Control/pause".visible:
				$"../../Control/pause".position.y=DisplayServer.window_get_size().y
			if abs(linear_velocity.y)>20:
				$"../../Control/pause".visible=true
				$"../../Control/pause/dead/next".visible=false
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		body.up()


func _on_body_entered(body: Node) -> void:
	if body.get_parent().get_parent().name=="墙"  and gamerun:
		$"../../Control/pause".visible=true
		$"../../Control/pause/dead/next".visible=false
		gamerun=false
		add_child(fx.instantiate())
		$"立方体_001".visible=false
		$"VehicleWheel3D/柱体_001".visible=false
		$"VehicleWheel3D2/柱体_001".visible=false
		$"VehicleWheel3D3/柱体_001".visible=false
		$"VehicleWheel3D4/柱体_001".visible=false

func running():
	gamerun=true
