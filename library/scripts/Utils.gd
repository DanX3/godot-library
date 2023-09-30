class_name Utils extends Node


static func rand_dir() -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(0.0, 2.0 * PI))

static func rand_rect2(rect: Rect2) -> Vector2:
	return rect.position + rect.size * Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0))
