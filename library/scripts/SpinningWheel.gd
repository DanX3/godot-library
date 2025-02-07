extends Control

signal spin_finished(index)

@export var num_slots = 8  # Number of segments on the wheel
@export var spin_duration = 2.0  # Duration of one full spin in seconds
@export var deceleration_duration = 1.0 # Duration of the slow down at the end

enum SpinDirection { CLOCKWISE, COUNTERCLOCKWISE }

var current_angle = 0.0
var current_index = 0  # Keep track of the current slot index
var spinning = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("move_left"):
		spin_wheel(SpinDirection.COUNTERCLOCKWISE)
	elif Input.is_action_just_pressed("move_right"):
		spin_wheel(SpinDirection.CLOCKWISE)

func spin_wheel(direction: SpinDirection):
	if spinning:
		print("already spinning")
		return  # Prevent multiple spins at once

	spinning = true

	var target_index = current_index
	if direction == SpinDirection.CLOCKWISE:
		target_index = (current_index + 1) #d% num_slots
	elif direction == SpinDirection.COUNTERCLOCKWISE:
		target_index = (current_index - 1) # % num_slots # handles negative indices

	var target_angle = (360.0 / num_slots) * target_index
	print("rotation from %d to %d" % [rotation_degrees, target_angle])

	var tween = get_tree().create_tween().tween_property(
		self,
		"rotation_degrees",
		target_angle, # spin one full rotation and land on the target
		spin_duration)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		spinning = false
		#current_index = (current_index + num_slots) % num_slots
		var actual_index = (current_index + num_slots) % num_slots
		print("current index: " + str(actual_index))
		#rotation_degrees = fmod((rotation_degrees + 360), 360)
		emit_signal("spin_finished", current_index))  # Emit the current index)
	current_index = target_index # update current index
	#current_index = (current_index + num_slots) % num_slots


# Example usage (e.g., in a button's `pressed` signal):
func _on_spin_clockwise_button_pressed():
	spin_wheel(SpinDirection.CLOCKWISE)

func _on_spin_counterclockwise_button_pressed():
	spin_wheel(SpinDirection.COUNTERCLOCKWISE)
