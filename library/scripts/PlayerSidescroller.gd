extends CharacterBody2D

@export var gravity := 1600.0
@export var jump_force := 900
@export var speed := 500.0
## for how many ms the player can still jump even not being on floor
@export var is_on_floor_delay_ms := 100

const MaxAirJumps = 1

var air_jumps_left = MaxAirJumps
var was_on_floor_ms = 0


func _physics_process(delta):
	var x = Input.get_axis("move_left", "move_right")
	var y = velocity.y + delta * gravity

	if is_on_floor():
		y = 0.0
		was_on_floor_ms = Time.get_ticks_msec()
		air_jumps_left = MaxAirJumps
	var was_on_floor = Time.get_ticks_msec() - was_on_floor_ms < is_on_floor_delay_ms
	if Input.is_action_just_pressed("move_up"):
		if was_on_floor:
			y = -jump_force
		elif air_jumps_left > 0:
			air_jumps_left -= 1
			y = -jump_force
	velocity = Vector2(move_toward(velocity.x, x * speed, 20.0), y)
	move_and_slide()


func is_moving():
	return velocity.length_squared() > 0.0
