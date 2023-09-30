@tool
class_name Spawner extends Node2D

@export var node_scene: PackedScene
@export var parent_path: String
@export var rects: Array[Rect2]

var _thresholds : Array[float]

func _ready():
	_prepare_thresholds();

func spawn() -> Node:
	var new_node = node_scene.instantiate()
	var parent = get_node(parent_path)
	new_node.global_position = global_position
	if rects != null and not rects.is_empty():
		var rect = _get_random_shape()
		new_node.global_position = global_position + Utils.rand_rect2(rect)
	parent.call_deferred("add_child", new_node)
	return new_node

func _get_random_shape():
	var rand = randf()
	for i in range(_thresholds.size()):
		if rand < _thresholds[i]:
			return rects[i]

# thresholds are used to get a random shape 
# to make their probability linearly dependent on their relative area
func _prepare_thresholds():
	var total_area = 0.0
	for rect in rects:
		total_area += rect.get_area()
	
	var relative_areas = []
	var progression = 0.0
	for rect in rects:
		var relative_area = rect.get_area() / total_area
		relative_areas.append(relative_area)
		progression += relative_area
		_thresholds.append(progression)
	

# draw shape in editor
func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _draw():
	if rects != null:
		for rect in rects:
			if rect != null:
				draw_rect(rect, Color(Color.DODGER_BLUE, 0.5))
