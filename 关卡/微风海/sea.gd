extends MeshInstance3D
func _process(delta: float) -> void:
	mesh.material.heightmap_texture.noise.offset.x+=0.1
