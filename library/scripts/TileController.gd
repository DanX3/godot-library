extends CharacterBody2D

## This class represent the player controller for a tile based movement
## The player moves by tweening from one cell position to the other.
## The player correctly calls the methods `on_player_face` and `on_player_leave`
## when starts looking at a colliding node and when it looks away respectively
## This is used to display some sort of feedback that the player is able to interact with a node

@onready var raycast = $RayCast2D
@onready var pivot = $Sprite2D

# speed of the tween movement
const SPEED = 200.0
# set the tile size. Since the game will be structured around this, it is a const
const tileSize = 64
## If pressed quickly, less than this time duration,
## the player only changes facing direction without actually moving
@export var moveDelayMs := 100
@export var frontSprite: Texture2D
@export var backSprite: Texture2D
var walking := false
var timer: Timer
var lastDir := Vector2.ZERO
var facingDir := Vector2.RIGHT
# the node the player is looking at, namely what collides with the raycast
var facingNode: Node = null


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
			_leave_facing_node()
			facingDir = lastDir
			update_graphics(facingDir)
			timer.stop()
		velocity = Vector2.ZERO
		return

	lastDir = selectedDir
	# prevent walking against a wall, just change facing direction
	if not can_walk(selectedDir):
		facingDir = selectedDir
		_face_node()
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
	_leave_facing_node()
	walking = true
	facingDir = dir
	update_graphics(facingDir)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + dir * tileSize, tileSize / SPEED)
	tween.finished.connect(
		func():
			walking = false
			_face_node()
	)


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


func _face_node():
	var collider = raycast.get_collider()
	if collider == facingNode:
		return
	if collider != null and collider.has_method("on_player_face"):
		collider.on_player_face(self)
		facingNode = collider


func _leave_facing_node():
	if facingNode != null:
		facingNode.on_player_leave(self)
	facingNode = null
