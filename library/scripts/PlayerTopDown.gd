extends CharacterBody2D

@export var speed := 600

var walk_dir: Vector2
@export var pivot: Node2D
@onready var player = $AnimationPlayer

func _ready() -> void:
	set_meta("player", true)

func _physics_process(delta):
	if player.is_playing() and player.current_animation == "jump" or player.current_animation == "attack_1":
		return
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("move_up", "move_down")
	walk_dir = Vector2(x, y).normalized()
	velocity = speed * walk_dir
	move_and_slide()
	if abs(velocity.x) > 0.0:
		pivot.scale.x = sign(velocity.x)
		
	if velocity.length_squared() == 0:
		player.play("idle")
	else:
		player.play("run")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		player.play("jump")
	
	if Input.is_action_just_pressed("light"):
		player.play("attack_1")

func turn_green():
	$Pivot/Icon.modulate = Color.GREEN_YELLOW
