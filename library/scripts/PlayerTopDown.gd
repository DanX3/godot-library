extends CharacterBody2D

@export var speed := 200
@export var camera: Camera2D
@export var camera_distance := 200.0
@export var camera_reactivity := 1
@export var player: AnimationPlayer
@export var moveTree: MoveTree

var walk_dir: Vector2
var camera_point := Vector2.ZERO
@onready var pivot = $Pivot

func _process(delta):
	if camera != null:
		camera_point = camera_distance * walk_dir
		camera.position = lerp(camera.position, camera_point, delta * camera_reactivity)

func _physics_process(delta):
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_up", "move_down")
	walk_dir = Vector2(x, y).normalized()
	velocity = speed * walk_dir
	move_and_slide()
	if abs(velocity.x) > 0.0:
		pivot.scale.x = sign(velocity.x)
	_manage_anim()

func _manage_anim():
	if moveTree.isPlaying:
		return
	if abs(velocity.x + velocity.y) > 0.0:
		player.play("walk")
	else:
		player.play("idle")

func _on_move_tree_play_anim(anim_name):
	player.play(anim_name)
