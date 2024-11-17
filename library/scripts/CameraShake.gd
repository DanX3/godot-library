class_name CameraShake extends Node

@export var scale := 20.0
@export var period := 0.01
@export var duration_s := 1.0

var parent_start_position: Vector2


func shake():
	parent_start_position = get_parent().position
	var tween = get_tree().create_tween()
	tween.tween_method(offset_parent, 1.0, 0.0, duration_s)
	tween.finished.connect(func(): get_parent().position = parent_start_position)


func offset_parent(t: float):
	var offset = Vector2(0.0, t * scale * sin(t / period))
	get_parent().position = parent_start_position + offset
