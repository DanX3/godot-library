class_name FreeAfter extends Node

@export var duration:= 1.0

func _ready():
	await get_tree().create_timer(duration).timeout
	get_parent().queue_free()
	

static func create(duration: float)->FreeAfter:
	var new_instance = FreeAfter.new()
	new_instance.duration = duration
	return new_instance
