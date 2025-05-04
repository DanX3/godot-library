## The InputListener class works by making it start listening for inputs
## for a period of time. At the end of the duration, the user can `consume()` the event
## effectively resetting the class
## This class is supposed to be used for combo attacks, listening for input events during the attack
## animation to switch to the next combo
class_name ComboListener extends Node

## Which actions to listen for
@export var actions: Array[String]
## How long the player has to hold the button to trigger a long press
@export var long_press_ms := 300

enum EventType { Press, Release, LongPress, LongRelease }

## Emitted when the internal listened event changed. Use this signal to listen for
## events before calling consume()
signal changed_action(action: String, event: EventType)

class ListenerEvent:
	var action: String
	var type: EventType
	
	static func create(action: String, type: EventType):
		var instance = ListenerEvent.new()
		instance.action = action
		instance.type = type
		return instance


var can_listen := false
var last_action_name := ""
var last_action_time := 0
var last_action_type := EventType.Press

func start_listening():
	can_listen = true

func _process(delta: float) -> void:
	if not can_listen or last_action_name.is_empty() or last_action_type != EventType.Press:
		return
	
	if Input.is_action_pressed(last_action_name) \
		and last_action_type == EventType.Press \
		and last_action_time + long_press_ms < Time.get_ticks_msec():
			_set_action(last_action_name, EventType.LongPress)

func _unhandled_input(event: InputEvent) -> void:
	if not can_listen:
		return
	
	# filter for a specific action, return otherwise
	var matched_action := ""
	for action in actions:
		if event.is_action(action):
			matched_action = action
			break
	if matched_action.is_empty():
		return
	
	if event.is_pressed():
		_set_action(matched_action, EventType.Press)
	
	if event.is_released():
		if _is_action(last_action_name, EventType.Press):
			_set_action(last_action_name, EventType.Release)
		elif _is_action(last_action_name, EventType.LongPress):
			_set_action(last_action_name, EventType.LongRelease)


func consume() -> ListenerEvent:
	var result = ListenerEvent.create(last_action_name, last_action_type)
	last_action_name = ""
	last_action_time = 0
	can_listen = false
	return result


func _set_action(name: String, type: EventType):
	last_action_name = name
	last_action_type = type
	last_action_time = Time.get_ticks_msec()
	changed_action.emit(name, type)


func _is_action(name: String, type: EventType) -> bool:
	return last_action_name == name and last_action_type == type
