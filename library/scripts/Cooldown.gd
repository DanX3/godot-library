class_name Cooldown extends Node

signal cooled_down

@export var duration := 1.0
var can_trigger := true
var timer: Timer

func _ready():
	timer = Timer.new()
	timer.wait_time = duration
	timer.autostart = false
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	can_trigger = true
	emit_signal("cooled_down")

func start():
	can_trigger = false
	timer.start(duration)

## Return a boolean indicating if the cooldown is ready to be used or not
func is_ready():
	print("is ready: ", can_trigger)
	return can_trigger

func get_progress() -> float:
	if can_trigger:
		return 1.0
		
	return (timer.wait_time - timer.time_left) / timer.wait_time

