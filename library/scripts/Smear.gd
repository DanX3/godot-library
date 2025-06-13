@tool
@icon("res://library/assets/smear_icon.png")
class_name Smear extends Node2D

@export var line: Line2D
@export var draw_smear = true
@export var duration_ms := 100
@export var min_distance = 10.0
var points_ts : PackedInt32Array

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
	
	if line == null:
		return
	
	var removeCount = 0
	var time = Time.get_ticks_msec()
	for i in points_ts:
		if time > i:
			removeCount += 1
		
	for i in range(removeCount):
		line.remove_point(0)
		points_ts.remove_at(0)
	
	
	if draw_smear:
		if line.get_point_count() == 0 or (line.get_point_position(line.get_point_count() - 1)).distance_squared_to(global_position) > min_distance * min_distance:
			line.add_point(global_position - line.get_parent().global_position)
			points_ts.append(Time.get_ticks_msec() + duration_ms)
	else:
		line.clear_points()
		points_ts.clear()
	

func _draw() -> void:
	if line == null:
		return
	var line_width = 0.5 * line.width
	draw_circle(Vector2.ZERO, line_width, Color(0, 1, 1, 0.5), false, 2);
	#draw_line(line_width * Vector2.DOWN, line_width * Vector2.UP, Color(0, 1, 1, 0.5), 2)
	#draw_line(line_width * Vector2.LEFT, line_width * Vector2.RIGHT, Color(0, 1, 1, 0.5), 2)
