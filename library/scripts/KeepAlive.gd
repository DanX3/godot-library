class_name KeepAlive extends Node

@export var duration := 1.0
@export var reparent_node: String

var timer: Timer

func keep_alive():
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start(duration)
	get_parent().reparent(get_node(reparent_node))

func _on_timer_timeout():
	get_parent().queue_free()
	timer.queue_free()
	
