class_name FSM extends Node

signal entered_state(new_state, old_state)
signal exited_state(old_state)

@export var label_debug: Label

var state = null

func set_state(new_state):
	if new_state == state:
		return
		
	if state != null:
		emit_signal("exited_state", state)
	
	emit_signal("entered_state", new_state, state)
	state = new_state
	if label_debug != null:
		label_debug.text = str(state)
