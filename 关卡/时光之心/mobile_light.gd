extends PathFollow3D
var speed=1
var way=1
func _process(delta: float) -> void:
	progress_ratio+=float(way*speed)/100
	if progress_ratio>0.98:
		way=-1
	if progress<0.02:
		way=1
	
