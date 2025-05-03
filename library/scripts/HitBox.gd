## The hitbox works paired with the hurtbox
## Set the damage of the hitbox to a reasonable value and correctly set the
## collision mask/layer
class_name HitBox extends Area2D

signal hit(area: Area2D)

@export var damage := -1

## Optionally the hurtbox may filter by ID to prevent multiple collision with the same hitbox
## Refresh the ID before the start of the attack to mark it as a different attack
var id = -1

func _ready() -> void:
	monitoring = false

func refresh_id():
	var new_id = randi()
	while new_id == id:
		new_id = randi()
	id = new_id
