extends Node3D
var is_ligtt=false
var light_length=10
@export var color=Color()
var get_object
func _ready() -> void:
	$GPUParticles3D.emitting=true
	$MeshInstance3D5.material_override.emission=color
func _process(delta: float) -> void:
	$MeshInstance3D5.mesh.height=light_length
	$MeshInstance3D5.position.y=light_length/2
	if $RayCast3D.is_colliding():
		light_length=$RayCast3D.global_position.distance_to($RayCast3D.get_collision_point())
		$GPUParticles3D.global_position=$RayCast3D.get_collision_point()
		get_object=$RayCast3D.get_collider()
		if get_object is VehicleBody3D:
			if $"../../../VehicleBody3D".gamerun:
				$"../../../../Control/pause".visible=true
				$"../../../VehicleBody3D".gamerun=false
				$"../../../VehicleBody3D".brake=1000
				$"../../../VehicleBody3D".add_child($"../../../VehicleBody3D".fx.instantiate())
				$"../../../VehicleBody3D/立方体_001".visible=false
				$"../../../VehicleBody3D/VehicleWheel3D/柱体_001".visible=false
				$"../../../VehicleBody3D/VehicleWheel3D2/柱体_001".visible=false
				$"../../../VehicleBody3D/VehicleWheel3D3/柱体_001".visible=false
				$"../../../VehicleBody3D/VehicleWheel3D4/柱体_001".visible=false
