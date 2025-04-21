extends CharacterBody2D

@export var speed := 200

var walk_dir: Vector2
@onready var pivot = $Pivot

func _ready() -> void:
	set_meta("player", true)

func _physics_process(delta):
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_up", "move_down")
	walk_dir = Vector2(x, y).normalized()
	velocity = speed * walk_dir
	move_and_slide()
	if abs(velocity.x) > 0.0:
		pivot.scale.x = sign(velocity.x)

func turn_green():
	$Pivot/Icon.modulate = Color.GREEN_YELLOW
