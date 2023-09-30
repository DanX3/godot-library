class_name FollowCursor extends Node2D

@onready var parent = get_parent()

func _process(delta):
	parent.global_position = get_global_mouse_position()
