@tool
class_name IKManager extends Node


@export_tool_button("Toggle Editor IK") var reset_ik_in_editor_button = _toggle_ik
var update_ik_in_editor = false

func _toggle_ik():
	update_ik_in_editor = not update_ik_in_editor
	_update_recursive(get_parent())


func _update_recursive(node: Node):
	if node is TwoJointsIK:
		(node as TwoJointsIK).update_ik_in_editor = update_ik_in_editor
	
	for child in node.get_children():
		_update_recursive(child)
