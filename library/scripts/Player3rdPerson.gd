extends RigidBody3D

const SPEED = 150
const JUMP_FORCE = 60
@export var camera: Camera3D

func _physics_process(delta: float) -> void:
	var movement = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"))
	var force = camera.global_basis.x * movement.x + -camera.global_basis.z * movement.y
	force.y = 0
	apply_central_force(SPEED * force.normalized())
	
	if Input.is_action_just_pressed("jump") and get_contact_count() > 0:
		apply_central_impulse(JUMP_FORCE * Vector3.UP)
