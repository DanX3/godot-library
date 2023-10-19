class_name Utils extends Node

# returns a random direction vector
static func rand_dir() -> Vector2:
	return Vector2.RIGHT.rotated(randf_range(0.0, 2.0 * PI))

## returns a random position inside the provided Rect2
static func rand_rect2(rect: Rect2) -> Vector2:
	return rect.position + rect.size * Vector2(randf_range(0.0, 1.0), randf_range(0.0, 1.0))


func frame_freeze(time_scale: float, duration: float):
	var start_scale: float = Engine.time_scale
	Engine.time_scale = time_scale
	var tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", 1.0, 0.2 * duration).set_delay(0.8 * duration * time_scale)
	await tween.finished
	Engine.time_scale = start_scale

static func get_tile_at(tilemap: TileMap, global_pos: Vector2, layer: int) -> TileData:
	var local_pos = tilemap.to_local(global_pos)
	var coords = tilemap.local_to_map(local_pos)
	return tilemap.get_cell_tile_data(layer, coords)
