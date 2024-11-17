extends CharacterBody2D

@onready var raycast = $RayCast2D
@onready var pivot = $Sprite2D

const SPEED = 200.0
const tileSize = 64
@export var moveDelayMs := 100
@export var frontSprite: Texture2D
@export var backSprite: Texture2D
var walking = false
var timer: Timer
var lastDir := Vector2.ZERO
var facingDir := Vector2.RIGHT


func _ready() -> void:
	# timer setup
	timer = Timer.new()
	timer.wait_time = float(moveDelayMs) / 1000.0
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)


func _physics_process(_delta: float) -> void:
	if walking:
		return

	var selectedDir = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		selectedDir = Vector2.DOWN
	elif Input.is_action_pressed("move_up"):
		selectedDir = Vector2.UP
	elif Input.is_action_pressed("move_right"):
		selectedDir = Vector2.RIGHT
	elif Input.is_action_pressed("move_left"):
		selectedDir = Vector2.LEFT
	else:
		# if stopped pressing before the timer runs out
		# just change facing direction
		if not timer.is_stopped():
			facingDir = lastDir
			update_graphics(facingDir)
			timer.stop()
		velocity = Vector2.ZERO
		return

	lastDir = selectedDir
	# prevent walking against a wall, just change facing direction
	if not can_walk(selectedDir):
		facingDir = selectedDir
		update_graphics(facingDir)
		return

	# in case of still start, wait for timer
	if timer.is_stopped():
		if velocity == Vector2.ZERO:
			timer.start()
		else:
			walk(selectedDir)


func _on_timer_timeout():
	var walkDir = Vector2(
		Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")
	)
	if not can_walk(walkDir):
		velocity = Vector2.ZERO
		return
	velocity = walkDir
	walk(walkDir)


func walk(dir: Vector2):
	walking = true
	facingDir = dir
	update_graphics(facingDir)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir * tileSize, tileSize / SPEED)
	tween.finished.connect(func(): walking = false)


func can_walk(dir: Vector2) -> bool:
	raycast.target_position = 48 * dir
	raycast.force_raycast_update()
	return not raycast.is_colliding()


## custom function to update the character looks on screen
func update_graphics(dir: Vector2):
	if dir.x > 0:
		pivot.scale.x = 1
	elif dir.x < 0:
		pivot.scale.x = -1
	if dir == Vector2.UP:
		$Sprite2D.texture = backSprite
	else:
		$Sprite2D.texture = frontSprite
