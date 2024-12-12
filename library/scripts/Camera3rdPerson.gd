extends Camera3D

@export var CameraSensitivity = 0.01
@export var cameraPivot: SpringArm3D

@export var minYAngle = -0.1
@export var maxYAngle = 0.1

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var relativeMotion = (event as InputEventMouseMotion).relative
		if relativeMotion.x != 0:
			cameraPivot.rotation.y -= CameraSensitivity * relativeMotion.x
			
		if relativeMotion.y != 0:
			print(cameraPivot.rotation.x)
			cameraPivot.rotation.x -= CameraSensitivity * relativeMotion.y
			cameraPivot.rotation.x = clamp(cameraPivot.rotation.x, -0.5 * PI, 0)
	
