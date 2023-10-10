class_name MovePressed extends Node

@export var condition:= PressedCondition.All
@export var actions_required: Array[String]

signal started
signal finished

enum PressedCondition {
	All,
	AtLeastOne,
	OnlyOne
}


func is_move_valid() -> bool:
#	print("Checking move ", name)
	match condition:
		PressedCondition.AtLeastOne:
			for action in actions_required:
				if Input.is_action_just_pressed(action):
					return true
		PressedCondition.OnlyOne:
			var validCount = 0
			for action in actions_required:
				if Input.is_action_just_pressed(action):
					validCount += 1
			return validCount == 1
		PressedCondition.All:
			for action in actions_required:
				if not Input.is_action_just_pressed(action):
					return false
			return true
	return false
