extends Node

## The Shooter node emit a signal when it is time to shoot a projectile
## It can be configured using a frequency parameter and it emits signals
## while the configured action button is pressed; it stops when it is released

class_name Shooter

signal shoot

@export var action := ""
@export var frequency := 10.0

var period := 0.0
var timePassedSinceBlink = 0


func _unhandled_input(event):
	if Input.is_action_just_pressed(action) and timePassedSinceBlink > period:
		emit_signal("shoot")
		timePassedSinceBlink = 0


func _ready():
	period = round(1000.0 / frequency)


func _physics_process(delta):
	timePassedSinceBlink += round(delta * 1000)
	if not Input.is_action_pressed(action):
		return

	if timePassedSinceBlink >= period:
		timePassedSinceBlink -= period
		emit_signal("shoot")
