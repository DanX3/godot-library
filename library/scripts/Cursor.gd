extends Control

@export var initial_focus: Control
var tween: Tween
const DOT_PRODUCT_MIN = 0.9
var focused_control: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if initial_focus != null:
		call_deferred("focus", initial_focus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func focus(control: Control):
	var mouse_position = control.global_position + Vector2(0.0, 0.5 * control.size.y)
	Input.warp_mouse(mouse_position)
	global_position = mouse_position
	focused_control = control

func _input(event):
	var direction = Vector2.ZERO
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	# ignore if the input was not ui movement
	if direction.length_squared() == 0.0:
		return
	# this algorithm checks for all the control in group "focus"
	# with dot product lower than an acceptable threshold and focuses the control
	# closest to the origin position
	var control_to_focus = null
	var closest_distance = INF
	for c in get_tree().get_nodes_in_group("focus"):
		if c.get_instance_id() == focused_control.get_instance_id():
			continue
		if not c is Control:
			printerr("Control ", c.name, " is not a Control. Skipping...")
			continue
		var control = c as Control
		var distance = control.global_position - global_position
		var dot = distance.normalized().dot(direction)
		# skip if the control is not aligned with the selected direction
		if dot < DOT_PRODUCT_MIN:
			continue
		if distance.length() < closest_distance:
			closest_distance = distance.length()
			control_to_focus = control
	if control_to_focus != null:
		focus(control_to_focus)
	
