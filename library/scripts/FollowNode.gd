class_name FollowNode extends Node

@export var node_to_follow: Node2D

func _process(delta):
	get_parent().global_position = node_to_follow.global_position
