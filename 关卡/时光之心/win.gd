extends Area3D
func _ready() -> void:
	area_entered.connect($"../../../Control/run".win)
