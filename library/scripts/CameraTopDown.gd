extends Camera2D

@export var target: Node2D
@export var targetOffset := 200

@onready var targetPos = target.global_position
var minX: int
var minY: int
var maxX: int
var maxY: int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _refresh_limits():
	var p = target.global_position
	minX = min(minX, p.x)
	minY = min(minY, p.y)
	maxX = max(maxX, p.x)
	maxY = max(maxY, p.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p = target.global_position
	if p.x > maxX or p.x < minX or p.y > maxY or p.y < minY:
		_refresh_limits()
		global_position = p
