extends Control

signal selected(node_name: String)

@export var initial_focus: Control
@export var move_duration := 0.2
var tween: Tween
const DOT_PRODUCT_MIN = 0.75
var focused_control: WeakRef = weakref(null)
var scroll_container: WeakRef = weakref(null)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if initial_focus != null:
		call_deferred("focus", initial_focus)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## moves the cursor to the provided control
## check_scroll_container by default checks whether to make visible a control inside a scroll container
func focus(control: Control, check_scroll_container = true):
	# if the grandparent of the node is a scroll container
	# tries to focus it when scrolling
	if check_scroll_container:
		if control.get_parent().get_parent() is ScrollContainer:
			scroll_container = weakref(control.get_parent().get_parent())
		else:
			scroll_container = weakref(null)
		if scroll_container.get_ref() != null:
			(scroll_container.get_ref() as ScrollContainer).ensure_control_visible(control)
			call_deferred("focus", control, false)
	
	var mouse_position = control.global_position + Vector2(0.0, 0.5 * control.size.y)
	Input.warp_mouse(mouse_position)
	if tween != null and tween.is_running():
		tween.stop()
	tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "global_position", mouse_position, move_duration)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	focused_control = weakref(control)


## removes the reference to the previously focused control
func unfocus():
	focused_control = weakref(null)


func _input(event):
	if not visible:
		return
	
	if Input.is_action_just_pressed("ui_accept") \
		and focused_control.get_ref() != null:
		emit_signal("selected", focused_control.get_ref().name)
		return
	
	# interrupt held timer actions
	if Input.is_action_just_released("ui_down") \
		or Input.is_action_just_released("ui_up") \
		or Input.is_action_just_released("ui_left") \
		or Input.is_action_just_released("ui_right"):
			$TimerHeld.stop()
			$TimerHeldTick.stop()
	
	var direction = Vector2.ZERO
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	if direction.length_squared() == 0.0:
		# ignore if the input was not ui movement
		return
	else:
		# start the timer to account for held action
		$TimerHeld.start()
	var control_to_focus = _get_control_in_direction(direction)
	if control_to_focus != null:
		focus(control_to_focus)
	

## this algorithm checks for all the control in group "focus"
## with dot product lower than an acceptable threshold and focuses the control
## closest to the origin position
func _get_control_in_direction(direction: Vector2):
	var control_to_focus = null
	var closest_distance = INF
	for c in get_tree().get_nodes_in_group("focus"):
		if focused_control.get_ref() != null \
			and c.get_instance_id() == focused_control.get_ref().get_instance_id():
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
	return control_to_focus


func _on_timer_held_timeout():
	_focus_control_in_dir_pressed()
	$TimerHeldTick.start()
	

func _on_timer_held_tick_timeout():
	_focus_control_in_dir_pressed()


func _focus_control_in_dir_pressed():
	var direction = _get_pressed_dir()
	if direction != Vector2.ZERO:
		var control_to_focus = _get_control_in_direction(direction)
		if control_to_focus != null:
			focus(control_to_focus)


func _get_pressed_dir():
	if Input.is_action_pressed("ui_up"):
		return Vector2.UP
	if Input.is_action_pressed("ui_down"):
		return Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	return Vector2.ZERO
