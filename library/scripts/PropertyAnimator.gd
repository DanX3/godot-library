class_name PropertyAnimator extends Node

@export var property: String = ""
@export var speed = 1.0
@export var amplitude = 10.0
@export var value_offset = 0.0
@export var randomized = false

@onready var startTime = 0.0
var period_offset = 0.0


func _ready():
	if randomized:
		period_offset = randf_range(0.0, 100.0)


func _get_random(t: float) -> float:
	var s = sin(speed * 8 * t + 0.95 + period_offset)
	var c = cos(speed * 3 * t + 0.57 + period_offset)
	return amplitude * 0.5 * (s + c) + value_offset


func _process(delta):
	startTime += delta
	get_parent().set(property, _get_random(startTime))
