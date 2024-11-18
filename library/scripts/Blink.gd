extends Node

class_name Blink

@export var duration := 1.0
@export var frequency := 10
@export var properties: Dictionary

var period := 0.0
var blinking = false
var on = true
var timePassedSinceBlink = 0

@onready var parent = get_parent()

var originalProperties = {}


func _ready():
	period = round(1000.0 / frequency)
	for key in properties:
		var value = parent.get(key)
		originalProperties[key] = value
	print("ok")


func blink():
	timePassedSinceBlink = period
	blinking = true
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(
		func():
			blinking = false
			_set_properties(originalProperties)
	)


func _process(delta):
	if not blinking:
		return

	timePassedSinceBlink += round(delta * 1000)
	if timePassedSinceBlink >= period:
		on = not on
		timePassedSinceBlink -= period
		_set_properties(properties if on else originalProperties)


func _set_properties(props: Dictionary):
	for key in props:
		parent.set(key, props[key])
