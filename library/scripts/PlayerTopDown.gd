extends CharacterBody2D

@export var Speed := 200
@export var camera: Camera2D
@export var camera_distance := 200.0
@export var camera_reactivity := 1

var walk_dir: Vector2
var camera_point := Vector2.ZERO

func _process(delta):
	if camera != null:
		camera_point = camera_distance * walk_dir
		camera.position = lerp(camera.position, camera_point, delta * camera_reactivity)

func _physics_process(delta):
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_up", "move_down")
	walk_dir = Vector2(x, y).normalized()
	velocity = Speed * walk_dir
	move_and_slide()
