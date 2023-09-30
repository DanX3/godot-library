extends Camera3D

const SPEED = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const MOUSE_SENSITIVITY = 0.01

func _input(event):
	if event is InputEventMouseMotion:
		rotation += MOUSE_SENSITIVITY * Vector3(-event.relative.y, -event.relative.x, 0.0)

func _physics_process(delta):
	var direction = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_up", "move_down"))
	var basis = global_transform.basis
	var basis_x = (basis.x * Vector3(1.0, 0.0, 1.0)).normalized()
	var basis_z = (basis.z * Vector3(1.0, 0.0, 1.0)).normalized()
	var movement = direction.x * basis_x + direction.z * basis_z
	position += delta * movement * SPEED
	
