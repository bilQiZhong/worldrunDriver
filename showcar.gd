extends Node3D

func _ready() -> void:
	var bin=Node3D.new()
	bin.name="bin"
	add_child(bin)
func _on_setcar_item_activated(index: int) -> void:
	$bin.free()
	var bin=Node3D.new()
	bin.name="bin"
	add_child(bin)
	if $"../..".carindex==0:
		$bin.add_child(preload("res://车/小车/car.tscn").instantiate())
	elif $"../..".carindex==1:
		$bin.add_child(preload("res://车/大车/car.tscn").instantiate())



func _on_exit_button_down() -> void:
	var bin=Node3D.new()
	bin.name="bin"
	add_child(bin)
