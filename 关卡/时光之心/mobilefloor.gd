extends CharacterBody3D
var is_can=false
var abposition
func _ready() -> void:
	abposition=$"..".position
func _physics_process(delta: float) -> void:
		$"..".position=abposition
var is_o=true
func up():
	if is_o:
		$AnimationPlayer.play("up")
		is_o=false
