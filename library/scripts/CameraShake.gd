class_name CameraShake extends Node

@export var scale:= 1.0
@export var offset_y: Curve
@export var duration_s:= 1.0

var parent_start_position: Vector2

func shake():
	parent_start_position = get_parent().position
	var tween = get_tree().create_tween()
	tween.tween_method(offset_parent, 0.0, 1.0, duration_s)
	tween.finished.connect(func(): get_parent().position = parent_start_position)

func offset_parent(t: float):
	get_parent().position = parent_start_position \
		+ scale * Vector2(0.0, offset_y.sample(t))
