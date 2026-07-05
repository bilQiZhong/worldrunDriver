extends Control
var is_con=true
func _process(delta: float) -> void: 
	if get_child_count() > 1:
		if $"../../level".get_child(1) is VehicleBody3D  and is_con:
			$Button.button_down.connect($"../../level".get_child(1).running)
			is_con=false
func _ready() -> void:
	pass


func _on_dead_button_down() -> void:
	is_con=true
	$"../start/background".dud=0

func win(index):
	$"../pause".visible=true
	$"../pause/dead/next".visible=true
	$"../../level/VehicleBody3D".gamerun=false
	
	

func _on_setlevel_item_activated(index: int) -> void:
	is_con=true
	$"../start/background".dud=0

func _on_button_button_down() -> void:
	if not get_node_or_null("../../level/VehicleBody3D")==null:
		$".".visible=false
		$"../../level/VehicleBody3D".gamerun=true
