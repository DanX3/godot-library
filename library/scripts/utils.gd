class_name Utils extends Node


static func rand_dir() -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(0.0, 2.0 * PI))
