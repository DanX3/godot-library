extends Control

signal finished

@export var start_time = 0.0
@export var autostart = false

@onready var label = $Label
var time = 0.0
var time_direction = 1.0

func _ready() -> void:
	set_process(autostart)
	set_time(start_time)

func pause():
	set_process(false)

func start(reset: bool = false):
	if reset:
		time = start_time
	set_process(true)

func set_time(time_left: float):
	start_time = time_left
	time = time_left
	time_direction = -1.0 if time_left > 0.0 else 1.0

func _process(delta: float) -> void:
	time += delta * time_direction
	if start_time > 0.0 and time < 0.0:
		emit_signal("finished")
		time = 0.0
		set_process(false)
	label.text = "%.2f s" % time


func _on_finished() -> void:
	$Label/Blink.blink()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse = event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start(true)
