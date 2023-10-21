class_name MoveCondition extends Node

@export var animation: String
@export var object: Node
@export var function: String
@export var invert:= false

func is_move_valid() -> bool:
	print("is move valid?:", name)
	if invert:
		print(name, " yes")
		return not object.call(function)
	else:
		print(name, " yes")
		return object.call(function)
