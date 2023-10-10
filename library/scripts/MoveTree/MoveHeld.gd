### Move that need to be held to trigger the next animation
class_name MoveHeld extends Node


enum HoldType {
	LessThan,
	MoreThan,
}

## the list of actions that needs to be pressed to trigger the move
@export var actions_required: Array[String]
## wheter to hold the button more or less than the duration
@export var holdType:= HoldType.MoreThan
@export var hold_duration_ms: int

signal started
signal finished

var valid_timestamp = -1

func _unhandled_input(event):
	for action in actions_required:
		if not Input.is_action_pressed(action):
			valid_timestamp = -1
			return
	valid_timestamp = Time.get_ticks_msec()

func is_move_valid() -> bool:
	print("Checking hold move valid: ", str(valid_timestamp > 0 and Time.get_ticks_msec() - valid_timestamp > hold_duration_ms))
	if valid_timestamp < 0:
		return false
	var time_passed_ms = Time.get_ticks_msec() - valid_timestamp
	if holdType == HoldType.MoreThan:
		return time_passed_ms >= hold_duration_ms
	else:
		return time_passed_ms <= hold_duration_ms
	
func _get_root():
	var parent = get_parent()
	while (not parent is MoveTree):
		parent = parent.get_parent()
	return parent
