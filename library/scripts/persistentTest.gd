extends Sprite2D

@export var bound_x_min := 0.0
@export var bound_x_max := 1080.0

const SPEED = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var direction = 1.0

func _process(delta):
	position.x = position.x + direction * SPEED * delta
	if position.x < bound_x_min or position.x > bound_x_max:
		direction *= -1.0

func save():
	return {
		"direction": direction
	}
