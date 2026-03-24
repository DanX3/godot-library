extends Node

const GYRO_SENSITIVITY = 0.1

func _ready():
	# In this example we only use the first connected joypad (id 0).
	if 0 not in Input.get_connected_joypads():
		return

	if not Input.has_joy_motion_sensors(0):
		return

	# We must enable the motion sensors before using them.
	Input.set_joy_motion_sensors_enabled(0, true)

	# (Tell the users here that they need to put their joypads on a flat surface and wait for confirmation.)

	# Start the calibration process.
	calibrate_motion()

func _process(delta):
	# Only move the object if the joypad motion sensors are calibrated.
	if Input.is_joy_motion_sensors_calibrated(0):
		move_object(delta)

func calibrate_motion():
	print("calibrating joypad")
	Input.start_joy_motion_sensors_calibration(0)

	# Wait for some time.
	await get_tree().create_timer(1.0).timeout

	Input.stop_joy_motion_sensors_calibration(0)
	# The joypad is now calibrated.
	print("Joypad is calibrated")

func roundVec(vec: Vector3, amount: float) -> Vector3:
	vec.x = roundf(vec.x * amount) / amount
	vec.y = roundf(vec.y * amount) / amount
	vec.z = roundf(vec.z * amount) / amount
	return vec

func move_object(delta):
	var node: Node3D = $Controller

	var gyro := Input.get_joy_gyroscope(0)
	gyro = roundVec(gyro, 100.0)
	
	
	$CanvasLayer/Box/X.value = gyro.x
	$CanvasLayer/Box/Y.value = gyro.y
	$CanvasLayer/Box/Z.value = gyro.z
	$CanvasLayer/GyroValue.text = str(gyro)
	
	var accel := Input.get_joy_accelerometer(0)
	accel = roundVec(accel, 100.0)
	$CanvasLayer/Box3/X.value = accel.x
	$CanvasLayer/Box3/Y.value = accel.y
	$CanvasLayer/Box3/Z.value = accel.z
	$CanvasLayer/AccelValue.text = str(accel)
	
	node.rotation.x = accel.x * GYRO_SENSITIVITY # * delta # Use rotation around the Y axis (yaw) here.
	node.rotation.y = accel.y * GYRO_SENSITIVITY # * delta # Use rotation around the X axis (pitch) here.
	node.rotation.z = accel.z * GYRO_SENSITIVITY # * delta # Use rotation around the X axis (pitch) here.
	
	
	
	
