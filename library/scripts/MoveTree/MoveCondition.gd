class_name MoveCondition extends Node

@export var object: Node
@export var function: String
@export var invert:= false

func is_move_valid() -> bool:
	if invert:
		return not object.call(function)
	else:
		return object.call(function)
