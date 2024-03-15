class_name FollowNode extends Node

@export var node_to_follow: Node2D
@export var reparent := false
@export var free_delay := 0.0

func _ready():
	if reparent:
		get_parent().call_deferred("reparent", node_to_follow.get_parent())

func _process(delta):
	if node_to_follow != null:
		get_parent().global_position = node_to_follow.global_position
	elif free_delay > 0.0:
		destroy_after()
		set_process(false)
	else:
		get_parent().queue_free()

func destroy_after():
	var timer = Timer.new()
	timer.autostart = true
	timer.one_shot = true
	timer.timeout.connect(func(): get_parent().queue_free())
	add_child(timer)
	timer.start(free_delay)
	if get_parent() is CPUParticles2D or get_parent() is GPUParticles2D:
		get_parent().emitting = false
